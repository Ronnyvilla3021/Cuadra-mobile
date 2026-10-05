import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';

/// Única instancia de la base de datos de la app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Saldo actual de la caja en centavos (se actualiza solo).
final saldoCentavosProvider = StreamProvider<int>((ref) {
  return ref.watch(appDatabaseProvider).watchSaldoCentavos();
});
