import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/caja_queries.dart';
import '../../data/database/dashboard_queries.dart';
import '../../data/providers.dart';

final resumenDiaProvider = StreamProvider<ResumenDia>((ref) {
  return ref.watch(appDatabaseProvider).watchResumenDia();
});

final ultimosMovimientosProvider = StreamProvider<List<Movimiento>>((ref) {
  return ref.watch(appDatabaseProvider).watchMovimientos(limite: 5);
});
