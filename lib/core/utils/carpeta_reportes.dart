import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Carpeta privada de la app donde se guardan los PDF/Excel exportados.
/// La pantalla "Mis reportes" lista esta carpeta, y la exportación (Paso 9)
/// guarda aquí cada archivo que genera.
Future<Directory> carpetaReportes() async {
  final base = await getApplicationDocumentsDirectory();
  final carpeta = Directory('${base.path}${Platform.pathSeparator}reportes');
  if (!await carpeta.exists()) {
    await carpeta.create(recursive: true);
  }
  return carpeta;
}
