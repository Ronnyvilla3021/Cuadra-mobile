import 'package:drift/drift.dart';

import 'app_database.dart';
import 'enums.dart';

extension CategoriasQueries on AppDatabase {
  /// Crea una categoría propia. Falla si ya existe una con ese nombre
  /// (sin importar mayúsculas) para el mismo tipo.
  Future<int> crearCategoria(String nombre, TipoMovimiento tipo) async {
    final n = nombre.trim();
    if (n.isEmpty || n.length > 40) {
      throw ArgumentError.value(nombre, 'nombre', 'Entre 1 y 40 letras.');
    }
    if (await _existeNombre(n, tipo)) {
      throw StateError('Ya existe una categoría con ese nombre.');
    }
    return into(categorias).insert(
      CategoriasCompanion.insert(nombre: n, tipo: tipo),
    );
  }

  /// Las predeterminadas no se renombran (la app las busca por nombre).
  Future<void> renombrarCategoria(int id, String nombre) async {
    final n = nombre.trim();
    if (n.isEmpty || n.length > 40) {
      throw ArgumentError.value(nombre, 'nombre', 'Entre 1 y 40 letras.');
    }
    final c = await (select(categorias)..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    if (c == null || c.esPredeterminada) {
      throw StateError('Esta categoría no se puede cambiar.');
    }
    if (n.toLowerCase() != c.nombre.toLowerCase() &&
        await _existeNombre(n, c.tipo)) {
      throw StateError('Ya existe una categoría con ese nombre.');
    }
    await (update(categorias)..where((x) => x.id.equals(id)))
        .write(CategoriasCompanion(nombre: Value(n)));
  }

  /// Elimina una categoría propia. Sus movimientos pasan a "Otros ingresos" /
  /// "Otros gastos" para no perder ni dejar huérfano ningún registro.
  Future<void> eliminarCategoria(int id) {
    return transaction(() async {
      final c = await (select(categorias)..where((x) => x.id.equals(id)))
          .getSingleOrNull();
      if (c == null) return;
      if (c.esPredeterminada) {
        throw StateError('Esta categoría no se puede eliminar.');
      }
      final destino = await categoriaPredeterminadaId(
        c.tipo == TipoMovimiento.ingreso ? 'Otros ingresos' : 'Otros gastos',
        c.tipo,
      );
      await (update(movimientos)..where((m) => m.categoriaId.equals(id)))
          .write(MovimientosCompanion(categoriaId: Value(destino)));
      await (delete(categorias)..where((x) => x.id.equals(id))).go();
    });
  }

  Future<int> contarMovimientosDeCategoria(int id) async {
    final cuenta = movimientos.id.count();
    final fila = await (selectOnly(movimientos)
          ..addColumns([cuenta])
          ..where(movimientos.categoriaId.equals(id)))
        .getSingle();
    return fila.read(cuenta) ?? 0;
  }

  Future<bool> _existeNombre(String nombre, TipoMovimiento tipo) async {
    final todas = await (select(categorias)
          ..where((c) => c.tipo.equalsValue(tipo)))
        .get();
    return todas.any((c) => c.nombre.toLowerCase() == nombre.toLowerCase());
  }
}
