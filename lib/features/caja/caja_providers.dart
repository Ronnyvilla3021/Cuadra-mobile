import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/caja_queries.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';

typedef FiltroCaja = ({TipoMovimiento? tipo, int limite});

final movimientosCajaProvider =
    StreamProvider.family<List<Movimiento>, FiltroCaja>((ref, filtro) {
  return ref
      .watch(appDatabaseProvider)
      .watchMovimientos(tipo: filtro.tipo, limite: filtro.limite);
});

final categoriasProvider = StreamProvider<List<Categoria>>((ref) {
  return ref.watch(appDatabaseProvider).watchCategorias();
});
