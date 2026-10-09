import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/carpeta_reportes.dart';
import '../pro/pro_gate.dart';
import '../reportes/compartir_pdf.dart';
import '../reportes/descargar_pdf.dart';

final reportesGuardadosProvider = FutureProvider.autoDispose<List<File>>((
  ref,
) async {
  final carpeta = await carpetaReportes();
  final archivos = <File>[];
  await for (final e in carpeta.list()) {
    if (e is File && e.path.toLowerCase().endsWith('.pdf')) archivos.add(e);
  }
  archivos.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  return archivos;
});

/// Historial de reportes. Solo PRO.
class ReportesGuardadosScreen extends StatelessWidget {
  const ReportesGuardadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProGate(
      titulo: 'Mis reportes',
      icono: Icons.picture_as_pdf,
      descripcion:
          'Guarda el historial de todos tus reportes para verlos, compartirlos '
          'o descargarlos cuando quieras.',
      funciones: [
        (Icons.history, 'Historial'),
        (Icons.share, 'Compartir'),
        (Icons.download, 'Descargar'),
      ],
      child: _ListaReportes(),
    );
  }
}

/// Lista los PDF que Cuadra ha generado en este celular.
/// Tocar uno abre sus opciones: compartir, guardar en el celular o eliminar.
class _ListaReportes extends ConsumerWidget {
  const _ListaReportes();

  Future<void> _eliminar(BuildContext context, WidgetRef ref, File f) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar reporte'),
        content: Text(_nombre(f)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await f.delete();
      ref.invalidate(reportesGuardadosProvider);
    }
  }

  Future<void> _opciones(BuildContext context, WidgetRef ref, File f) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(_nombre(f), maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${_fecha(f.lastModifiedSync())}  ·  ${_tamano(f.lengthSync())}',
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Compartir'),
              onTap: () {
                Navigator.of(ctx).pop();
                compartirPdf(f);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Guardar en mi celular'),
              onTap: () {
                Navigator.of(ctx).pop();
                guardarPdfEnCelular(context, f);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Eliminar'),
              onTap: () {
                Navigator.of(ctx).pop();
                _eliminar(context, ref, f);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportes = ref.watch(reportesGuardadosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis reportes')),
      body: reportes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (archivos) {
          if (archivos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.picture_as_pdf_outlined, size: 56),
                    SizedBox(height: 12),
                    Text(
                      'Aún no has exportado reportes.\n'
                      'Los PDF que generes aparecerán aquí.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: archivos.length,
            itemBuilder: (context, i) {
              final f = archivos[i];
              return ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                title: Text(_nombre(f), maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${_fecha(f.lastModifiedSync())}  ·  ${_tamano(f.lengthSync())}'),
                onTap: () => _opciones(context, ref, f),
                trailing: IconButton(
                  tooltip: 'Opciones',
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _opciones(context, ref, f),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _nombre(File f) => f.path.split(Platform.pathSeparator).last;

String _fecha(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String _tamano(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
