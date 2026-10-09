import 'package:drift/drift.dart';

import '../../core/utils/fechas.dart';
import '../../data/database/app_database.dart';
import '../../data/database/enums.dart';
import '../../data/database/prestamos_queries.dart';

class FilaMovimiento {
  const FilaMovimiento({
    required this.fecha,
    required this.concepto,
    required this.categoria,
    required this.tipo,
    required this.montoCentavos,
  });

  final DateTime fecha;
  final String concepto;
  final String? categoria;
  final TipoMovimiento tipo;
  final int montoCentavos;
}

class FilaPagoEmpleado {
  const FilaPagoEmpleado({
    required this.fecha,
    required this.empleado,
    required this.tipoPago,
    required this.unidades,
    required this.tarifaCentavos,
    required this.bonificacionCentavos,
    required this.deduccionCentavos,
    required this.totalCentavos,
  });

  final DateTime fecha;
  final String empleado;
  final TipoPago tipoPago;
  final double unidades;
  final int tarifaCentavos;
  final int bonificacionCentavos;
  final int deduccionCentavos;
  final int totalCentavos;
}

/// Todo lo que lleva un reporte: movimientos de caja del período y los
/// préstamos entregados en ese período.
class DatosReporte {
  const DatosReporte({
    required this.desde,
    required this.hasta,
    required this.movimientos,
    required this.prestamos,
    required this.porCobrarTotalCentavos,
    this.pagosEmpleados = const [],
  });

  final DateTime desde;
  final DateTime hasta;
  final List<FilaMovimiento> movimientos;
  final List<ResumenPrestamo> prestamos;

  /// Lo que todavía deben todas las personas (no solo las del período).
  final int porCobrarTotalCentavos;

  /// Pagos a empleados hechos en el período.
  final List<FilaPagoEmpleado> pagosEmpleados;

  int get empleadosTotalCentavos =>
      pagosEmpleados.fold(0, (a, p) => a + p.totalCentavos);
  int get empleadosBonosCentavos =>
      pagosEmpleados.fold(0, (a, p) => a + p.bonificacionCentavos);
  int get empleadosDeduccionesCentavos =>
      pagosEmpleados.fold(0, (a, p) => a + p.deduccionCentavos);

  int get ingresosCentavos => _suma(TipoMovimiento.ingreso);
  int get gastosCentavos => _suma(TipoMovimiento.gasto);
  int get gananciaCentavos => ingresosCentavos - gastosCentavos;

  int _suma(TipoMovimiento tipo) => movimientos
      .where((m) => m.tipo == tipo)
      .fold(0, (a, m) => a + m.montoCentavos);

  /// Total por categoría, de mayor a menor.
  List<MapEntry<String, int>> porCategoria(TipoMovimiento tipo) {
    final mapa = <String, int>{};
    for (final m in movimientos.where((m) => m.tipo == tipo)) {
      final nombre = m.categoria ?? 'Sin categoría';
      mapa[nombre] = (mapa[nombre] ?? 0) + m.montoCentavos;
    }
    return mapa.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }

  int get prestadoCentavos =>
      prestamos.fold(0, (a, p) => a + p.prestamo.montoCentavos);
  int get cobradoCentavos => prestamos.fold(0, (a, p) => a + p.pagadoCentavos);
  int get pendienteCentavos =>
      prestamos.fold(0, (a, p) => a + p.pendienteCentavos);
}

extension ReportesQueries on AppDatabase {
  /// Junta los datos de un reporte. [desde] y [hasta] son días y ambos se
  /// incluyen completos.
  Future<DatosReporte> cargarDatosReporte({
    required DateTime desde,
    required DateTime hasta,
  }) async {
    final inicio = soloDia(desde);
    final fin = DateTime(hasta.year, hasta.month, hasta.day + 1);

    final consulta = select(movimientos).join([
      leftOuterJoin(categorias, categorias.id.equalsExp(movimientos.categoriaId)),
    ])
      ..where(
        movimientos.fecha.isBiggerOrEqualValue(inicio) &
            movimientos.fecha.isSmallerThanValue(fin),
      )
      ..orderBy([
        OrderingTerm.asc(movimientos.fecha),
        OrderingTerm.asc(movimientos.id),
      ]);

    final filas = await consulta.get();
    final lista = [
      for (final f in filas)
        FilaMovimiento(
          fecha: f.readTable(movimientos).fecha,
          concepto: f.readTable(movimientos).concepto,
          categoria: f.readTableOrNull(categorias)?.nombre,
          tipo: f.readTable(movimientos).tipo,
          montoCentavos: f.readTable(movimientos).montoCentavos,
        ),
    ];

    final todos = await watchResumenPrestamos().first;
    final delPeriodo = todos
        .where(
          (p) =>
              !p.prestamo.fechaPrestamo.isBefore(inicio) &&
              p.prestamo.fechaPrestamo.isBefore(fin),
        )
        .toList()
      ..sort((a, b) => a.prestamo.fechaPrestamo.compareTo(b.prestamo.fechaPrestamo));
    final porCobrar = todos.fold<int>(
      0,
      (a, p) => a + (p.pendienteCentavos > 0 ? p.pendienteCentavos : 0),
    );

    final consultaPagos = select(pagosEmpleado).join([
      innerJoin(empleados, empleados.id.equalsExp(pagosEmpleado.empleadoId)),
    ])
      ..where(
        pagosEmpleado.fecha.isBiggerOrEqualValue(inicio) &
            pagosEmpleado.fecha.isSmallerThanValue(fin),
      )
      ..orderBy([
        OrderingTerm.asc(pagosEmpleado.fecha),
        OrderingTerm.asc(pagosEmpleado.id),
      ]);
    final filasPagos = await consultaPagos.get();
    final pagos = [
      for (final f in filasPagos)
        FilaPagoEmpleado(
          fecha: f.readTable(pagosEmpleado).fecha,
          empleado: f.readTable(empleados).nombre,
          tipoPago: f.readTable(empleados).tipoPago,
          unidades: f.readTable(pagosEmpleado).unidadesTrabajadas,
          tarifaCentavos: f.readTable(pagosEmpleado).tarifaAplicadaCentavos,
          bonificacionCentavos: f.readTable(pagosEmpleado).bonificacionCentavos,
          deduccionCentavos: f.readTable(pagosEmpleado).deduccionCentavos,
          totalCentavos: f.readTable(pagosEmpleado).totalPagadoCentavos,
        ),
    ];

    return DatosReporte(
      desde: inicio,
      hasta: soloDia(hasta),
      movimientos: lista,
      prestamos: delPeriodo,
      porCobrarTotalCentavos: porCobrar,
      pagosEmpleados: pagos,
    );
  }
}
