import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';

/// Única instancia de la base de datos de la app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Lectura única del negocio al arrancar (la usa el splash).
final negocioInicialProvider = FutureProvider<Negocio?>((ref) {
  return ref.watch(appDatabaseProvider).negocioActual();
});

/// Negocio configurado (null si todavía no se hizo el onboarding).
final negocioProvider = StreamProvider<Negocio?>((ref) {
  return ref.watch(appDatabaseProvider).watchNegocio();
});

/// Saldo actual de la caja en centavos (se actualiza solo).
final saldoCentavosProvider = StreamProvider<int>((ref) {
  return ref.watch(appDatabaseProvider).watchSaldoCentavos();
});
