import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/negocio_queries.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('cambia el nombre del negocio', () async {
    await db.crearNegocio(nombre: 'Tienda vieja');
    await db.renombrarNegocio('  Tienda nueva ');
    expect((await db.negocioActual())!.nombre, 'Tienda nueva');
  });

  test('rechaza nombres demasiado cortos', () async {
    await db.crearNegocio(nombre: 'Tienda');
    await expectLater(db.renombrarNegocio(' a '), throwsArgumentError);
    expect((await db.negocioActual())!.nombre, 'Tienda');
  });
}
