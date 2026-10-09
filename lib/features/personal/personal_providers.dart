import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/empleados_queries.dart';
import '../../data/providers.dart';

final resumenEmpleadosProvider = StreamProvider<List<ResumenEmpleado>>((ref) {
  return ref.watch(appDatabaseProvider).watchResumenEmpleados();
});

final pagosEmpleadoProvider =
    StreamProvider.family<List<PagoEmpleado>, int>((ref, empleadoId) {
  return ref.watch(appDatabaseProvider).watchPagosEmpleado(empleadoId);
});
