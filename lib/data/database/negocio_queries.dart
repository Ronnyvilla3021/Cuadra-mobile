import 'package:drift/drift.dart';

import 'app_database.dart';

extension NegocioQueries on AppDatabase {
  /// Cambia el nombre del negocio (hay un solo negocio por instalación).
  Future<void> renombrarNegocio(String nombre) async {
    final limpio = nombre.trim();
    if (limpio.length < 2) {
      throw ArgumentError.value(nombre, 'nombre', 'El nombre es muy corto.');
    }
    await update(negocios).write(NegociosCompanion(nombre: Value(limpio)));
  }
}
