import 'dart:io';

import 'package:share_plus/share_plus.dart';

/// Abre la hoja de compartir de Android (WhatsApp, correo, Drive, "Guardar
/// en el dispositivo", etc.) con el PDF adjunto.
Future<void> compartirPdf(File archivo) {
  return SharePlus.instance.share(
    ShareParams(
      files: [XFile(archivo.path, mimeType: 'application/pdf')],
      text: 'Reporte de Cuadra',
    ),
  );
}
