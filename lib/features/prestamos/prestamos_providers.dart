import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/prestamos_queries.dart';
import '../../data/providers.dart';

final resumenPrestamosProvider = StreamProvider<List<ResumenPrestamo>>((ref) {
  return ref.watch(appDatabaseProvider).watchResumenPrestamos();
});

final abonosProvider =
    StreamProvider.family<List<AbonoPrestamo>, int>((ref, prestamoId) {
  return ref.watch(appDatabaseProvider).watchAbonos(prestamoId);
});
