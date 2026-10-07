import 'package:drift/drift.dart';

import '../../core/utils/fechas.dart';
import 'app_database.dart';
import 'enums.dart';

/// Estado de un préstamo: con deuda (rojo), pago parcial (morado), pagado (verde).
enum EstadoPrestamo { pendiente, parcial, pagado }

class ResumenPrestamo {
  const ResumenPrestamo({
    required this.prestamo,
    required this.cliente,
    required this.pagadoCentavos,
  });

  final Prestamo prestamo;
  final Cliente cliente;
  final int pagadoCentavos;

  int get pendienteCentavos => prestamo.montoCentavos - pagadoCentavos;

  EstadoPrestamo get estado {
    if (pendienteCentavos <= 0) return EstadoPrestamo.pagado;
    if (pagadoCentavos == 0) return EstadoPrestamo.pendiente;
    return EstadoPrestamo.parcial;
  }

  bool estaVencido([DateTime? ahora]) {
    final v = prestamo.fechaVencimiento;
    if (v == null || estado == EstadoPrestamo.pagado) return false;
    return soloDia(v).isBefore(soloDia(ahora ?? DateTime.now()));
  }
}

extension PrestamosQueries on AppDatabase {
  /// Todos los préstamos con su persona y lo pagado hasta ahora.
  Stream<List<ResumenPrestamo>> watchResumenPrestamos() {
    final pagado = abonosPrestamo.montoCentavos.sum();
    final query = select(prestamos).join([
      innerJoin(clientes, clientes.id.equalsExp(prestamos.clienteId)),
      leftOuterJoin(
        abonosPrestamo,
        abonosPrestamo.prestamoId.equalsExp(prestamos.id),
      ),
    ])
      ..addColumns([pagado])
      ..groupBy([prestamos.id])
      ..orderBy([
        OrderingTerm.desc(prestamos.fechaPrestamo),
        OrderingTerm.desc(prestamos.id),
      ]);

    return query.watch().map(
          (filas) => [
            for (final f in filas)
              ResumenPrestamo(
                prestamo: f.readTable(prestamos),
                cliente: f.readTable(clientes),
                pagadoCentavos: f.read(pagado) ?? 0,
              ),
          ],
        );
  }

  Stream<List<AbonoPrestamo>> watchAbonos(int prestamoId) {
    return (select(abonosPrestamo)
          ..where((a) => a.prestamoId.equals(prestamoId))
          ..orderBy([
            (a) => OrderingTerm.desc(a.fecha),
            (a) => OrderingTerm.desc(a.id),
          ]))
        .watch();
  }

  /// Crea un préstamo (y a la persona, si es nueva). Si sale de la caja,
  /// registra el gasto correspondiente en la misma transacción.
  Future<int> crearPrestamo({
    required String nombrePersona,
    String? telefono,
    required int montoCentavos,
    DateTime? fechaPrestamo,
    DateTime? fechaVencimiento,
    String? nota,
    required bool salioDeCaja,
  }) async {
    final nombre = nombrePersona.trim();
    if (nombre.isEmpty) {
      throw ArgumentError.value(nombrePersona, 'nombrePersona', 'Falta el nombre.');
    }
    if (montoCentavos <= 0) {
      throw ArgumentError.value(
        montoCentavos,
        'montoCentavos',
        'El monto debe ser mayor que cero.',
      );
    }
    final fecha = fechaPrestamo ?? DateTime.now();
    if (fechaVencimiento != null &&
        soloDia(fechaVencimiento).isBefore(soloDia(fecha))) {
      throw ArgumentError.value(
        fechaVencimiento,
        'fechaVencimiento',
        'La fecha de pago no puede ser anterior al préstamo.',
      );
    }
    final tel = (telefono?.trim().isEmpty ?? true) ? null : telefono!.trim();

    return transaction(() async {
      // La misma persona se reutiliza aunque cambien mayúsculas o espacios.
      final todos = await select(clientes).get();
      final existente = todos
          .where((c) => c.nombre.trim().toLowerCase() == nombre.toLowerCase())
          .firstOrNull;

      final int clienteId;
      if (existente == null) {
        clienteId = await into(clientes).insert(
          ClientesCompanion.insert(nombre: nombre, telefono: Value(tel)),
        );
      } else {
        clienteId = existente.id;
        if (tel != null && tel != existente.telefono) {
          await (update(clientes)..where((c) => c.id.equals(clienteId)))
              .write(ClientesCompanion(telefono: Value(tel)));
        }
      }

      int? movimientoId;
      if (salioDeCaja) {
        movimientoId = await into(movimientos).insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.gasto,
            concepto: 'Préstamo a $nombre',
            montoCentavos: montoCentavos,
            fecha: fecha,
            categoriaId: Value(
              await categoriaPredeterminadaId(
                'Otros gastos',
                TipoMovimiento.gasto,
              ),
            ),
            origen: const Value(OrigenMovimiento.prestamo),
          ),
        );
      }

      final prestamoId = await into(prestamos).insert(
        PrestamosCompanion.insert(
          clienteId: clienteId,
          montoCentavos: montoCentavos,
          fechaPrestamo: fecha,
          fechaVencimiento: Value(fechaVencimiento),
          nota: Value(nota),
          salioDeCaja: Value(salioDeCaja),
          movimientoId: Value(movimientoId),
        ),
      );

      final idMov = movimientoId;
      if (idMov != null) {
        await (update(movimientos)..where((m) => m.id.equals(idMov)))
            .write(MovimientosCompanion(origenId: Value(prestamoId)));
      }
      return prestamoId;
    });
  }

  /// Registra un pago. No puede superar lo pendiente. Si el préstamo salió de
  /// la caja, el pago entra a la caja como ingreso.
  Future<int> registrarAbono({
    required int prestamoId,
    required int montoCentavos,
    DateTime? fecha,
    String? nota,
  }) async {
    if (montoCentavos <= 0) {
      throw ArgumentError.value(
        montoCentavos,
        'montoCentavos',
        'El monto debe ser mayor que cero.',
      );
    }

    return transaction(() async {
      final prestamo = await (select(prestamos)
            ..where((p) => p.id.equals(prestamoId)))
          .getSingle();
      final abonos = await (select(abonosPrestamo)
            ..where((a) => a.prestamoId.equals(prestamoId)))
          .get();
      final pagado = abonos.fold<int>(0, (s, a) => s + a.montoCentavos);
      if (montoCentavos > prestamo.montoCentavos - pagado) {
        throw StateError('El pago supera lo que se debe.');
      }

      final cuando = fecha ?? DateTime.now();
      int? idMov;
      if (prestamo.salioDeCaja) {
        final cliente = await (select(clientes)
              ..where((c) => c.id.equals(prestamo.clienteId)))
            .getSingle();
        idMov = await into(movimientos).insert(
          MovimientosCompanion.insert(
            tipo: TipoMovimiento.ingreso,
            concepto: 'Cobro de préstamo - ${cliente.nombre}',
            montoCentavos: montoCentavos,
            fecha: cuando,
            categoriaId: Value(
              await categoriaPredeterminadaId(
                'Pago recibido',
                TipoMovimiento.ingreso,
              ),
            ),
            origen: const Value(OrigenMovimiento.cobroPrestamo),
          ),
        );
      }

      final abonoId = await into(abonosPrestamo).insert(
        AbonosPrestamoCompanion.insert(
          prestamoId: prestamoId,
          montoCentavos: montoCentavos,
          fecha: cuando,
          nota: Value(nota),
          movimientoId: Value(idMov),
        ),
      );

      final idMovimiento = idMov;
      if (idMovimiento != null) {
        await (update(movimientos)..where((m) => m.id.equals(idMovimiento)))
            .write(MovimientosCompanion(origenId: Value(abonoId)));
      }
      return abonoId;
    });
  }

  /// Elimina el préstamo, sus pagos y los movimientos de caja que generó.
  Future<void> eliminarPrestamo(int id) {
    return transaction(() async {
      final prestamo = await (select(prestamos)..where((p) => p.id.equals(id)))
          .getSingleOrNull();
      if (prestamo == null) return;

      final abonos = await (select(abonosPrestamo)
            ..where((a) => a.prestamoId.equals(id)))
          .get();
      final idsMovimientos = <int>[
        for (final a in abonos) ?a.movimientoId,
        ?prestamo.movimientoId,
      ];

      await (delete(abonosPrestamo)..where((a) => a.prestamoId.equals(id))).go();
      await (delete(prestamos)..where((p) => p.id.equals(id))).go();
      if (idsMovimientos.isNotEmpty) {
        await (delete(movimientos)..where((m) => m.id.isIn(idsMovimientos)))
            .go();
      }
    });
  }
}
