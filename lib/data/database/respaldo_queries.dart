import 'dart:io';

import 'app_database.dart';

/// El archivo no es una copia de seguridad válida de Cuadra.
class RespaldoInvalido implements Exception {
  const RespaldoInvalido(this.mensaje);
  final String mensaje;

  @override
  String toString() => mensaje;
}

extension RespaldoQueries on AppDatabase {
  /// Nombres de las tablas, padres primero (para insertar).
  List<String> get _tablasEnOrden => [
        negocios.actualTableName,
        categorias.actualTableName,
        clientes.actualTableName,
        movimientos.actualTableName,
        empleados.actualTableName,
        prestamos.actualTableName,
        abonosPrestamo.actualTableName,
        pagosEmpleado.actualTableName,
      ];

  static String _sql(String texto) => texto.replaceAll("'", "''");

  /// Crea una copia completa y consistente de la base en [carpeta].
  /// Es un archivo SQLite normal con extensión .cuadra.
  Future<File> crearRespaldo(Directory carpeta, {DateTime? ahora}) async {
    final d = ahora ?? DateTime.now();
    String dos(int n) => n.toString().padLeft(2, '0');
    final nombre = 'Cuadra_respaldo_${d.year}-${dos(d.month)}-${dos(d.day)}'
        '_${dos(d.hour)}${dos(d.minute)}${dos(d.second)}.cuadra';
    final archivo = File('${carpeta.path}${Platform.pathSeparator}$nombre');
    if (await archivo.exists()) await archivo.delete();
    await customStatement("VACUUM INTO '${_sql(archivo.path)}'");
    return archivo;
  }

  /// Reemplaza TODOS los datos actuales por los de la copia [archivo].
  /// Si la copia no es válida lanza [RespaldoInvalido] y no cambia nada.
  Future<void> restaurarRespaldo(File archivo) async {
    try {
      await customStatement("ATTACH DATABASE '${_sql(archivo.path)}' AS respaldo");
    } catch (_) {
      // Un archivo que no es SQLite falla ya al abrirlo.
      throw const RespaldoInvalido('Este archivo no es una copia de Cuadra.');
    }
    try {
      final int version;
      final bool tieneNegocios;
      try {
        final v = await customSelect('PRAGMA respaldo.user_version').getSingle();
        version = v.read<int>('user_version');
        tieneNegocios = (await customSelect(
          "SELECT name FROM respaldo.sqlite_master "
          "WHERE type = 'table' AND name = '${negocios.actualTableName}'",
        ).get())
            .isNotEmpty;
      } catch (_) {
        throw const RespaldoInvalido('Este archivo no es una copia de Cuadra.');
      }
      if (!tieneNegocios) {
        throw const RespaldoInvalido('Este archivo no es una copia de Cuadra.');
      }
      if (version != schemaVersion) {
        throw const RespaldoInvalido(
          'La copia es de otra versión de la app y no se puede restaurar.',
        );
      }

      await transaction(() async {
        for (final t in _tablasEnOrden.reversed) {
          await customStatement('DELETE FROM main.$t');
        }
        for (final t in _tablasEnOrden) {
          await customStatement('INSERT INTO main.$t SELECT * FROM respaldo.$t');
        }
      });
    } finally {
      await customStatement('DETACH DATABASE respaldo');
    }
    markTablesUpdated(allTables);
  }

  /// Borra todo lo que el usuario guardó. Se conservan las categorías
  /// predeterminadas (la app las necesita).
  Future<void> borrarTodosLosDatos() async {
    await transaction(() async {
      await delete(abonosPrestamo).go();
      await delete(prestamos).go();
      await delete(pagosEmpleado).go();
      await delete(empleados).go();
      await delete(movimientos).go();
      await delete(clientes).go();
      await (delete(categorias)..where((c) => c.esPredeterminada.equals(false)))
          .go();
      await delete(negocios).go();
    });
  }
}
