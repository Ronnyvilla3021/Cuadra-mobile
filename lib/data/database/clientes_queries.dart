import 'package:drift/drift.dart';

import 'app_database.dart';

extension ClientesQueries on AppDatabase {
  /// Guarda (o borra, si viene vacío) el teléfono de una persona.
  Future<void> actualizarTelefonoCliente(int id, String? telefono) async {
    final limpio = telefono?.trim();
    await (update(clientes)..where((c) => c.id.equals(id))).write(
      ClientesCompanion(
        telefono: Value((limpio == null || limpio.isEmpty) ? null : limpio),
      ),
    );
  }
}
