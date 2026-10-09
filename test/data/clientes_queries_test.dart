import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/clientes_queries.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<Cliente> leer(int id) =>
      (db.select(db.clientes)..where((c) => c.id.equals(id))).getSingle();

  test('guarda el teléfono sin espacios sobrantes y lo puede borrar', () async {
    final id = await db.crearCliente(nombre: 'Carlos');

    await db.actualizarTelefonoCliente(id, ' 0991234567 ');
    expect((await leer(id)).telefono, '0991234567');

    await db.actualizarTelefonoCliente(id, '   ');
    expect((await leer(id)).telefono, isNull);
  });
}
