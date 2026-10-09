import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Guarda una copia del PDF donde el usuario elija en su celular
/// (Descargas, Documentos, una carpeta propia...). Usa el selector de Android,
/// por lo que no pide permisos.
Future<void> guardarPdfEnCelular(BuildContext context, File archivo) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final nombre = archivo.path.split(Platform.pathSeparator).last;
    final destino = await FilePicker.saveFile(
      dialogTitle: 'Guardar reporte',
      fileName: nombre,
      bytes: await archivo.readAsBytes(),
    );
    if (destino == null) return; // el usuario canceló
    messenger.showSnackBar(
      const SnackBar(content: Text('Reporte guardado en tu celular.')),
    );
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('No se pudo guardar el reporte: $e')),
    );
  }
}
