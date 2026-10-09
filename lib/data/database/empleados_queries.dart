import 'package:drift/drift.dart';

import 'app_database.dart';
import 'enums.dart';

/// Lo que se paga = tarifa x unidades + bonificación - deducciones.
/// El redondeo es al centavo más cercano.
int calcularTotalPago({
  required int tarifaCentavos,
  required double unidades,
  int bonificacionCentavos = 0,
  int deduccionCentavos = 0,
}) {
  return (tarifaCentavos * unidades).round() +
      bonificacionCentavos -
      deduccionCentavos;
}

class ResumenEmpleado {
  const ResumenEmpleado({
    required this.empleado,
    required this.pagadoMesCentavos,
    required this.pagadoTotalCentavos,
    required this.ultimoPago,
  });

  final Empleado empleado;
  final int pagadoMesCentavos;
  final int pagadoTotalCentavos;
  final DateTime? ultimoPago;
}

extension EmpleadosQueries on AppDatabase {
  /// Empleados activos con lo pagado este mes y en total.
  Stream<List<ResumenEmpleado>> watchResumenEmpleados() {
    final consulta = select(empleados).join([
      leftOuterJoin(
        pagosEmpleado,
        pagosEmpleado.empleadoId.equalsExp(empleados.id),
      ),
    ])
      ..where(empleados.activo.equals(true))
      ..orderBy([OrderingTerm.asc(empleados.nombre)]);

    return consulta.watch().map((filas) {
      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);
      final porId = <int, List<PagoEmpleado>>{};
      final datos = <int, Empleado>{};
      final orden = <int>[];
      for (final f in filas) {
        final e = f.readTable(empleados);
        if (!datos.containsKey(e.id)) {
          datos[e.id] = e;
          porId[e.id] = [];
          orden.add(e.id);
        }
        final p = f.readTableOrNull(pagosEmpleado);
        if (p != null) porId[e.id]!.add(p);
      }
      return [
        for (final id in orden)
          ResumenEmpleado(
            empleado: datos[id]!,
            pagadoMesCentavos: porId[id]!
                .where((p) => !p.fecha.isBefore(inicioMes))
                .fold(0, (a, p) => a + p.totalPagadoCentavos),
            pagadoTotalCentavos:
                porId[id]!.fold(0, (a, p) => a + p.totalPagadoCentavos),
            ultimoPago: porId[id]!.isEmpty
                ? null
                : porId[id]!
                    .map((p) => p.fecha)
                    .reduce((a, b) => a.isAfter(b) ? a : b),
          ),
      ];
    });
  }

  Stream<List<PagoEmpleado>> watchPagosEmpleado(int empleadoId) {
    return (select(pagosEmpleado)
          ..where((p) => p.empleadoId.equals(empleadoId))
          ..orderBy([
            (p) => OrderingTerm.desc(p.fecha),
            (p) => OrderingTerm.desc(p.id),
          ]))
        .watch();
  }

  Future<int> crearEmpleado({
    required String nombre,
    required TipoPago tipoPago,
    required int tarifaCentavos,
  }) {
    final n = nombre.trim();
    if (n.isEmpty) throw ArgumentError.value(nombre, 'nombre', 'Falta el nombre.');
    if (tarifaCentavos < 0) {
      throw ArgumentError.value(tarifaCentavos, 'tarifaCentavos', 'Tarifa no válida.');
    }
    return into(empleados).insert(
      EmpleadosCompanion.insert(
        nombre: n,
        tipoPago: tipoPago,
        tarifaCentavos: tarifaCentavos,
      ),
    );
  }

  /// Cambiar la tarifa no altera los pagos anteriores (guardan la suya).
  Future<void> actualizarEmpleado(
    int id, {
    required String nombre,
    required TipoPago tipoPago,
    required int tarifaCentavos,
  }) async {
    final n = nombre.trim();
    if (n.isEmpty) throw ArgumentError.value(nombre, 'nombre', 'Falta el nombre.');
    await (update(empleados)..where((e) => e.id.equals(id))).write(
      EmpleadosCompanion(
        nombre: Value(n),
        tipoPago: Value(tipoPago),
        tarifaCentavos: Value(tarifaCentavos),
      ),
    );
  }

  /// Se oculta, no se borra: así su historial de pagos sigue en los reportes.
  Future<void> desactivarEmpleado(int id) async {
    await (update(empleados)..where((e) => e.id.equals(id)))
        .write(const EmpleadosCompanion(activo: Value(false)));
  }

  /// Registra un pago y lo descuenta de la caja como gasto.
  Future<int> registrarPagoEmpleado({
    required int empleadoId,
    required double unidades,
    int bonificacionCentavos = 0,
    int deduccionCentavos = 0,
    DateTime? fecha,
    String? nota,
  }) {
    if (unidades < 0) {
      throw ArgumentError.value(unidades, 'unidades', 'No puede ser negativo.');
    }
    if (bonificacionCentavos < 0 || deduccionCentavos < 0) {
      throw ArgumentError('Bonificación y deducción no pueden ser negativas.');
    }

    return transaction(() async {
      final e = await (select(empleados)..where((x) => x.id.equals(empleadoId)))
          .getSingle();
      final total = calcularTotalPago(
        tarifaCentavos: e.tarifaCentavos,
        unidades: unidades,
        bonificacionCentavos: bonificacionCentavos,
        deduccionCentavos: deduccionCentavos,
      );
      if (total <= 0) {
        throw ArgumentError.value(total, 'total', 'El total a pagar debe ser mayor que cero.');
      }

      final cuando = fecha ?? DateTime.now();
      final movId = await into(movimientos).insert(
        MovimientosCompanion.insert(
          tipo: TipoMovimiento.gasto,
          concepto: 'Pago a ${e.nombre}',
          montoCentavos: total,
          fecha: cuando,
          categoriaId: Value(
            await categoriaPredeterminadaId('Otros gastos', TipoMovimiento.gasto),
          ),
          origen: const Value(OrigenMovimiento.pagoEmpleado),
        ),
      );
      final n = nota?.trim();
      final pagoId = await into(pagosEmpleado).insert(
        PagosEmpleadoCompanion.insert(
          empleadoId: empleadoId,
          unidadesTrabajadas: unidades,
          tarifaAplicadaCentavos: e.tarifaCentavos,
          bonificacionCentavos: Value(bonificacionCentavos),
          deduccionCentavos: Value(deduccionCentavos),
          totalPagadoCentavos: total,
          fecha: cuando,
          nota: Value((n == null || n.isEmpty) ? null : n),
          movimientoId: Value(movId),
        ),
      );
      await (update(movimientos)..where((m) => m.id.equals(movId)))
          .write(MovimientosCompanion(origenId: Value(pagoId)));
      return pagoId;
    });
  }

  /// Borra el pago y el gasto que generó en la caja.
  Future<void> eliminarPagoEmpleado(int pagoId) {
    return transaction(() async {
      final p = await (select(pagosEmpleado)..where((x) => x.id.equals(pagoId)))
          .getSingleOrNull();
      if (p == null) return;
      await (delete(pagosEmpleado)..where((x) => x.id.equals(pagoId))).go();
      final movId = p.movimientoId;
      if (movId != null) {
        await (delete(movimientos)..where((m) => m.id.equals(movId))).go();
      }
    });
  }
}
