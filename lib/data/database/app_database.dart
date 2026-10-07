import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

const _categoriasIngreso = [
  'Venta',
  'Servicio',
  'Pago recibido',
  'Otros ingresos',
];

const _categoriasGasto = [
  'Compra de mercadería',
  'Transporte',
  'Servicios',
  'Otros gastos',
];

@DriftDatabase(
  tables: [
    Negocios,
    Categorias,
    Movimientos,
    Clientes,
    Prestamos,
    AbonosPrestamo,
    Empleados,
    PagosEmpleado,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Base de datos real del dispositivo (archivo SQLite local).
  AppDatabase() : super(driftDatabase(name: 'cuadra'));

  /// Para pruebas: recibe un ejecutor en memoria.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _sembrarCategorias();
        },
        beforeOpen: (details) async {
          // SQLite no activa las llaves foráneas por defecto.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _sembrarCategorias() async {
    await batch((b) {
      b.insertAll(categorias, [
        for (final nombre in _categoriasIngreso)
          CategoriasCompanion.insert(
            nombre: nombre,
            tipo: TipoMovimiento.ingreso,
            esPredeterminada: const Value(true),
          ),
        for (final nombre in _categoriasGasto)
          CategoriasCompanion.insert(
            nombre: nombre,
            tipo: TipoMovimiento.gasto,
            esPredeterminada: const Value(true),
          ),
      ]);
    });
  }

  // ---------------------------------------------------------------- Negocio

  Future<int> crearNegocio({
    required String nombre,
    String? tipoNegocio,
    String moneda = 'USD',
    int saldoInicialCentavos = 0,
  }) async {
    return into(negocios).insert(
      NegociosCompanion.insert(
        nombre: nombre,
        tipoNegocio: Value(tipoNegocio),
        moneda: Value(moneda),
        saldoInicialCentavos: Value(saldoInicialCentavos),
      ),
    );
  }

  Future<Negocio?> negocioActual() {
    return (select(negocios)
          ..orderBy([(n) => OrderingTerm.asc(n.id)])
          ..limit(1)).getSingleOrNull();
  }

  Stream<Negocio?> watchNegocio() {
    return (select(negocios)
          ..orderBy([(n) => OrderingTerm.asc(n.id)])
          ..limit(1)).watchSingleOrNull();
  }

  // ------------------------------------------------------------------- Caja

  Future<int> registrarMovimiento({
    required TipoMovimiento tipo,
    required String concepto,
    required int montoCentavos,
    int? categoriaId,
    DateTime? fecha,
  }) async {
    _validarMonto(montoCentavos);
    return into(movimientos).insert(
      MovimientosCompanion.insert(
        tipo: tipo,
        concepto: concepto,
        montoCentavos: montoCentavos,
        fecha: fecha ?? DateTime.now(),
        categoriaId: Value(categoriaId),
      ),
    );
  }

  Stream<List<Movimiento>> watchUltimosMovimientos({int limite = 20}) {
    return (select(movimientos)
          ..orderBy([(m) => OrderingTerm.desc(m.fecha)])
          ..limit(limite))
        .watch();
  }

  /// Saldo de caja = saldo inicial + ingresos - gastos (siempre calculado).
  Stream<int> watchSaldoCentavos() {
    return customSelect(
      'SELECT '
      'COALESCE((SELECT saldo_inicial_centavos FROM negocios ORDER BY id LIMIT 1), 0) '
      '+ COALESCE((SELECT SUM(CASE WHEN tipo = ? THEN monto_centavos '
      'ELSE -monto_centavos END) FROM movimientos), 0) AS saldo',
      variables: [Variable.withString(TipoMovimiento.ingreso.name)],
      readsFrom: {movimientos, negocios},
    ).watchSingle().map((row) => row.read<int>('saldo'));
  }

  // ----------------------------------------------------------------- Personas

  Future<int> crearCliente({required String nombre, String? telefono}) async {
    return into(clientes).insert(
      ClientesCompanion.insert(nombre: nombre, telefono: Value(telefono)),
    );
  }

  // ---------------------------------------------------------------- Helpers

  Future<int?> categoriaPredeterminadaId(String nombre, TipoMovimiento tipo) async {
    final fila = await (select(categorias)
          ..where((c) => c.nombre.equals(nombre) & c.tipo.equalsValue(tipo)))
        .getSingleOrNull();
    return fila?.id;
  }

  void _validarMonto(int montoCentavos) {
    if (montoCentavos <= 0) {
      throw ArgumentError.value(
        montoCentavos,
        'montoCentavos',
        'El monto debe ser mayor que cero.',
      );
    }
  }
}
