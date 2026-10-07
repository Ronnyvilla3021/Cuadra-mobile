import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/database/negocio_queries.dart';
import '../../data/providers.dart';
import '../pro/pro_providers.dart';
import 'tema_provider.dart';

/// Mantener igual que `version:` en pubspec.yaml (sin el +build).
const kVersionApp = '1.0.0';

class AjustesScreen extends ConsumerWidget {
  const AjustesScreen({super.key});

  Future<void> _editarNombre(
    BuildContext context,
    WidgetRef ref,
    String actual,
  ) async {
    final nuevo = await showDialog<String>(
      context: context,
      builder: (_) => _NombreDialog(inicial: actual),
    );
    if (nuevo != null && nuevo != actual) {
      await ref.read(appDatabaseProvider).renombrarNegocio(nuevo);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final negocio = ref.watch(negocioProvider).value;
    final modo = ref.watch(temaProvider);
    final esPro = ref.watch(isProProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          const _Seccion('Mi negocio'),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: const Text('Nombre del negocio'),
            subtitle: Text(negocio?.nombre ?? '--'),
            trailing: const Icon(Icons.edit_outlined),
            onTap: negocio == null
                ? null
                : () => _editarNombre(context, ref, negocio.nombre),
          ),
          const ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Moneda'),
            subtitle: Text(r'USD - Dólar ($)'),
          ),

          const _Seccion('Apariencia'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                  label: Text('Sistema'),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_outlined),
                  label: Text('Claro'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_outlined),
                  label: Text('Oscuro'),
                ),
              ],
              selected: {modo},
              onSelectionChanged: (s) =>
                  ref.read(temaProvider.notifier).establecer(s.first),
            ),
          ),

          const _Seccion('Cuadra PRO'),
          ListTile(
            leading: const Icon(Icons.workspace_premium, color: AppColors.pro),
            title: Text(esPro ? 'Cuadra PRO activo' : 'Cuadra PRO'),
            subtitle: Text(
              esPro ? 'Gracias por tu suscripción' : 'Desbloquea todas las funciones',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/pro'),
          ),

          const _Seccion('Datos'),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: const Text('Mis reportes'),
            subtitle: const Text('PDF exportados en este celular'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/ajustes/reportes'),
          ),
          const ListTile(
            enabled: false,
            leading: Icon(Icons.cloud_upload_outlined),
            title: Text('Copia de seguridad'),
            subtitle: Text('Próximamente (PRO)'),
          ),

          const _Seccion('Acerca de'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versión'),
            subtitle: Text(kVersionApp),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo);

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        titulo,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _NombreDialog extends StatefulWidget {
  const _NombreDialog({required this.inicial});

  final String inicial;

  @override
  State<_NombreDialog> createState() => _NombreDialogState();
}

class _NombreDialogState extends State<_NombreDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ctrl = TextEditingController(
    text: widget.inicial,
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_ctrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nombre del negocio'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _ctrl,
          autofocus: true,
          maxLength: 80,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(counterText: ''),
          validator: (v) =>
              (v?.trim().length ?? 0) < 2 ? 'Escribe el nombre de tu negocio' : null,
          onFieldSubmitted: (_) => _guardar(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
