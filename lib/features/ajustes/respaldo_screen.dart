import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/database/respaldo_queries.dart';
import '../../data/providers.dart';
import '../pro/pro_gate.dart';

/// Copia de seguridad sin nube: un archivo .cuadra que el usuario guarda donde
/// quiera (celular, Drive, WhatsApp) y puede restaurar luego. Solo PRO.
class RespaldoScreen extends StatelessWidget {
  const RespaldoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProGate(
      titulo: 'Copia de seguridad',
      icono: Icons.cloud_upload_outlined,
      descripcion:
          'Guarda una copia de todos tus datos y recupérala si cambias de '
          'celular o reinstalas la app.',
      funciones: [
        (Icons.download, 'Guardar copia'),
        (Icons.share, 'Compartir'),
        (Icons.restore, 'Restaurar'),
      ],
      child: _RespaldoContenido(),
    );
  }
}

class _RespaldoContenido extends ConsumerStatefulWidget {
  const _RespaldoContenido();

  @override
  ConsumerState<_RespaldoContenido> createState() => _RespaldoContenidoState();
}

class _RespaldoContenidoState extends ConsumerState<_RespaldoContenido> {
  bool _trabajando = false;

  Future<void> _envolver(Future<void> Function() accion) async {
    if (_trabajando) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _trabajando = true);
    try {
      await accion();
    } on RespaldoInvalido catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.mensaje)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Algo salió mal: $e')));
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<File> _crearTemporal() async {
    final temp = await getTemporaryDirectory();
    return ref.read(appDatabaseProvider).crearRespaldo(temp);
  }

  Future<void> _guardarEnCelular() => _envolver(() async {
        final messenger = ScaffoldMessenger.of(context);
        final copia = await _crearTemporal();
        try {
          final destino = await FilePicker.saveFile(
            dialogTitle: 'Guardar copia de seguridad',
            fileName: copia.path.split(Platform.pathSeparator).last,
            bytes: await copia.readAsBytes(),
          );
          if (destino != null) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Copia guardada en tu celular.')),
            );
          }
        } finally {
          if (await copia.exists()) await copia.delete();
        }
      });

  Future<void> _compartir() => _envolver(() async {
        final copia = await _crearTemporal();
        await SharePlus.instance.share(
          ShareParams(files: [XFile(copia.path)], text: 'Copia de seguridad de Cuadra'),
        );
      });

  Future<void> _restaurar() async {
    final seguro = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restaurar copia'),
        content: const Text(
          'Se REEMPLAZARÁN todos los datos que tienes ahora por los de la copia.\n\n'
          'Tip: antes guarda una copia de lo actual.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Elegir archivo'),
          ),
        ],
      ),
    );
    if (seguro != true || !mounted) return;

    await _envolver(() async {
      final messenger = ScaffoldMessenger.of(context);
      final elegido = await FilePicker.pickFile();
      if (elegido == null) return;

      final temp = await getTemporaryDirectory();
      final archivo = File('${temp.path}${Platform.pathSeparator}restaurar.cuadra');
      await archivo.writeAsBytes(await elegido.readAsBytes(), flush: true);
      try {
        await ref.read(appDatabaseProvider).restaurarRespaldo(archivo);
        messenger.showSnackBar(
          const SnackBar(content: Text('Copia restaurada. Tus datos ya están de vuelta.')),
        );
      } finally {
        if (await archivo.exists()) await archivo.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Copia de seguridad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'La copia incluye tu negocio, caja, categorías, préstamos y empleados. '
            'No incluye los PDF ni las preferencias de la app.\n\n'
            'Se guarda como un archivo que tú eliges dónde dejar: tu celular, '
            'Google Drive o enviártelo por WhatsApp. No usamos servidores.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _trabajando ? null : _guardarEnCelular,
            icon: const Icon(Icons.download),
            label: const Text('Guardar copia en mi celular'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _trabajando ? null : _compartir,
            icon: const Icon(Icons.share),
            label: const Text('Compartir copia'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _trabajando ? null : _restaurar,
            icon: const Icon(Icons.restore),
            label: const Text('Restaurar desde un archivo'),
          ),
          if (_trabajando)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
