import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/categorias_queries.dart';
import 'package:mi_negocio/data/database/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('crea, rechaza repetidas y renombra categorías propias', () async {
    final id = await db.crearCategoria(' Propinas ', TipoMovimiento.ingreso);
    expect(
      () => db.crearCategoria('propinas', TipoMovimiento.ingreso),
      throwsStateError,
    );
    // El mismo nombre en el otro tipo sí se permite.
    await db.crearCategoria('Propinas', TipoMovimiento.gasto);

    await db.renombrarCategoria(id, 'Propinas extra');
    final c = await (db.select(db.categorias)..where((x) => x.id.equals(id)))
        .getSingle();
    expect(c.nombre, 'Propinas extra');
  });

  test('las predeterminadas no se renombran ni se borran', () async {
    final venta = await db.categoriaPredeterminadaId('Venta', TipoMovimiento.ingreso);
    expect(() => db.renombrarCategoria(venta!, 'Otra'), throwsStateError);
    expect(() => db.eliminarCategoria(venta!), throwsStateError);
  });

  test('al eliminar una categoría sus movimientos pasan a "Otros gastos"', () async {
    final id = await db.crearCategoria('Limpieza', TipoMovimiento.gasto);
    await db.registrarMovimiento(
      tipo: TipoMovimiento.gasto,
      concepto: 'Cloro',
      montoCentavos: 300,
      categoriaId: id,
    );
    expect(await db.contarMovimientosDeCategoria(id), 1);

    await db.eliminarCategoria(id);

    final otros = await db.categoriaPredeterminadaId('Otros gastos', TipoMovimiento.gasto);
    final m = (await db.select(db.movimientos).get()).single;
    expect(m.categoriaId, otros);
    final quedan = await (db.select(db.categorias)..where((x) => x.id.equals(id))).get();
    expect(quedan, isEmpty);
  });
}
