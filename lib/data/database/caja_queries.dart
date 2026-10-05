import 'package:drift/drift.dart';

import 'app_database.dart';
import 'enums.dart';

/// Consultas de la Caja. Están en una extensión para no tocar la base ni
/// regenerar código de Drift.
extension CajaQueries on AppDatabase {
  /// Movimientos del más reciente al más antiguo, con filtro opcional por tipo.
  Stream<List<Movimiento>> watchMovimientos({
    TipoMovimiento? tipo,
    int limite = 30,
  }) {
    final query = select(movimientos);
    if (tipo != null) {
      query.where((m) => m.tipo.equalsValue(tipo));
    }
    query
      ..orderBy([
        (m) => OrderingTerm.desc(m.fecha),
        (m) => OrderingTerm.desc(m.id),
      ])
      ..limit(limite);
    return query.watch();
  }

  Stream<List<Categoria>> watchCategorias() {
    return (select(categorias)..orderBy([(c) => OrderingTerm.asc(c.id)]))
        .watch();
  }

  /// Elimina un movimiento SOLO si fue registrado a mano. Los que nacen de un
  /// pago de fiado o de empleado no se tocan (romperían esos registros).
  Future<bool> eliminarMovimientoManual(int id) async {
    final borrados = await (delete(movimientos)
          ..where(
            (m) => m.id.equals(id) & m.origen.equalsValue(OrigenMovimiento.manual),
          ))
        .go();
    return borrados > 0;
  }
}
