import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/carpeta_reportes.dart';
import '../../data/database/respaldo_queries.dart';
import '../../data/providers.dart';
import '../alertas/servicio_alertas.dart';
import '../prestamos/ajustes_prestamos.dart';
import 'reportes_guardados_screen.dart';
import 'tema_provider.dart';

/// Pide confirmación escribiendo BORRAR y elimina todo lo guardado:
/// base de datos, reportes PDF y preferencias. Luego vuelve al inicio.
Future<void> confirmarYBorrarDatos(BuildContext context, WidgetRef ref) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => const _ConfirmarBorradoDialog(),
  );
  if (ok != true || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  try {
    await ref.read(appDatabaseProvider).borrarTodosLosDatos();

    final carpeta = await carpetaReportes();
    await for (final e in carpeta.list()) {
      if (e is File) await e.delete();
    }

    await ref.read(sharedPrefsProvider)?.clear();
    ref
      ..invalidate(temaProvider)
      ..invalidate(avisosCobroProvider)
      ..invalidate(ajustesPrestamosProvider)
      ..invalidate(reportesGuardadosProvider);

    router.go('/');
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('No se pudieron borrar los datos: $e')),
    );
  }
}

class _ConfirmarBorradoDialog extends StatefulWidget {
  const _ConfirmarBorradoDialog();

  @override
  State<_ConfirmarBorradoDialog> createState() => _ConfirmarBorradoDialogState();
}

class _ConfirmarBorradoDialogState extends State<_ConfirmarBorradoDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habilitado = _ctrl.text.trim().toUpperCase() == 'BORRAR';
    return AlertDialog(
      title: const Text('Borrar todos mis datos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Se eliminarán tu negocio, la caja, los préstamos, los empleados, '
            'tus reportes PDF y tus preferencias. No se puede deshacer.\n\n'
            'Si quieres conservarlos, haz antes una copia de seguridad.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(labelText: 'Escribe BORRAR para confirmar'),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: habilitado ? () => Navigator.of(context).pop(true) : null,
          child: const Text('Borrar todo'),
        ),
      ],
    );
  }
}
