// ignore_for_file: recursive_getters
// (Drift usa `check(columna.isBiggerThanValue(0))` dentro de la propia
// columna; el analizador lo marca como getter recursivo, pero es lo correcto.)

import 'package:drift/drift.dart';

import 'enums.dart';

// Reglas de diseño:
// - Todo el dinero va en centavos (int), nunca en decimales.
// - El saldo de caja y la deuda de cada cliente NO se guardan: se calculan.
// - Clientes y empleados se "desactivan" (activo = false), no se borran,
//   para no perder el historial.

@DataClassName('Negocio')
class Negocios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get tipoNegocio => text().nullable()();
  TextColumn get moneda => text().withDefault(const Constant('USD'))();
  IntColumn get saldoInicialCentavos =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Categoria')
class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  TextColumn get tipo => textEnum<TipoMovimiento>()();
  BoolColumn get esPredeterminada =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {nombre, tipo},
      ];
}

@DataClassName('Movimiento')
@TableIndex(name: 'idx_movimientos_fecha', columns: {#fecha})
class Movimientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => textEnum<TipoMovimiento>()();
  TextColumn get concepto => text().withLength(min: 1, max: 120)();
  IntColumn get categoriaId => integer()
      .nullable()
      .references(Categorias, #id, onDelete: KeyAction.setNull)();
  IntColumn get montoCentavos =>
      integer().check(montoCentavos.isBiggerThanValue(0))();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get origen =>
      textEnum<OrigenMovimiento>().withDefault(const Constant('manual'))();

  /// id del registro que originó este movimiento (pago de fiado, etc.).
  IntColumn get origenId => integer().nullable()();
}

@DataClassName('Cliente')
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get telefono => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}

/// Un préstamo de dinero a una persona (tabla Clientes).
/// Pagado = SUM(abonos); pendiente = monto - pagado (siempre calculados).
@DataClassName('Prestamo')
@TableIndex(name: 'idx_prestamos_cliente', columns: {#clienteId})
class Prestamos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId => integer().references(Clientes, #id)();
  IntColumn get montoCentavos =>
      integer().check(montoCentavos.isBiggerThanValue(0))();
  DateTimeColumn get fechaPrestamo => dateTime()();

  /// Fecha en que se espera el pago (null = sin fecha).
  DateTimeColumn get fechaVencimiento => dateTime().nullable()();
  TextColumn get nota => text().nullable()();

  /// Si el dinero salió de la caja (se decide al crear el préstamo y ya no
  /// cambia, aunque el usuario modifique el ajuste después).
  BoolColumn get salioDeCaja => boolean().withDefault(const Constant(true))();

  /// Gasto generado en la caja al prestar (si salió de la caja).
  IntColumn get movimientoId => integer()
      .nullable()
      .references(Movimientos, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}

/// Pagos parciales o totales de un préstamo.
@DataClassName('AbonoPrestamo')
@TableIndex(name: 'idx_abonos_prestamo', columns: {#prestamoId})
class AbonosPrestamo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get prestamoId => integer().references(Prestamos, #id)();
  IntColumn get montoCentavos =>
      integer().check(montoCentavos.isBiggerThanValue(0))();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get nota => text().nullable()();

  /// Ingreso generado en la caja por este pago (si el préstamo salió de ella).
  IntColumn get movimientoId => integer()
      .nullable()
      .references(Movimientos, #id, onDelete: KeyAction.setNull)();
}

@DataClassName('Empleado')
class Empleados extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get tipoPago => textEnum<TipoPago>()();
  IntColumn get tarifaCentavos =>
      integer().check(tarifaCentavos.isBiggerOrEqualValue(0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('PagoEmpleado')
class PagosEmpleado extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get empleadoId => integer().references(Empleados, #id)();

  /// Horas o días trabajados (según el tipo de pago). Admite decimales.
  RealColumn get unidadesTrabajadas => real()();

  /// Tarifa vigente al momento del pago (queda como respaldo histórico).
  IntColumn get tarifaAplicadaCentavos => integer()();
  IntColumn get bonificacionCentavos =>
      integer().withDefault(const Constant(0))();
  IntColumn get deduccionCentavos =>
      integer().withDefault(const Constant(0))();

  /// Monto final pagado = tarifa x unidades + bonificación - deducciones.
  IntColumn get totalPagadoCentavos => integer()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get nota => text().nullable()();

  /// Gasto generado en la caja por este pago.
  IntColumn get movimientoId => integer()
      .nullable()
      .references(Movimientos, #id, onDelete: KeyAction.setNull)();
}
