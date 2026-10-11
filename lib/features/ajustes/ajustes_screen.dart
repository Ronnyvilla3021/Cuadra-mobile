import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/imagenes_app.dart';
import '../../data/database/negocio_queries.dart';
import '../../data/providers.dart';
import '../ads/ad_config.dart';
import '../alertas/servicio_alertas.dart';
import '../pro/pro_providers.dart';
import 'borrar_datos.dart';
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
    if (nuevo == null || nuevo == actual) return;
    final db = ref.read(appDatabaseProvider);
    if (ref.read(negocioProvider).value == null) {
      // Por si no hay negocio (p. ej. tras borrar los datos): se crea.
      await db.crearNegocio(nombre: nuevo);
    } else {
      await db.renombrarNegocio(nuevo);
    }
  }

  Future<void> _compartirApp() {
    return SharePlus.instance.share(
      ShareParams(
        text: 'Llevo la caja y los préstamos de mi negocio con Cuadra. '
            'Pruébala gratis: $kUrlPlayStore',
      ),
    );
  }

  Future<void> _calificarApp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await launchUrl(
        Uri.parse(kUrlPlayStore),
        mode: LaunchMode.externalApplication,
      );
      if (ok) return;
    } catch (_) {}
    messenger.showSnackBar(
      const SnackBar(content: Text('No se pudo abrir Play Store.')),
    );
  }

  Future<void> _cambiarAvisos(WidgetRef ref, bool activos) async {
    await ref.read(avisosCobroProvider.notifier).establecer(activos);
    if (activos && AdConfig.disponible) {
      await ref.read(servicioAlertasProvider).pedirPermiso();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final negocio = ref.watch(negocioProvider).value;
    final avisos = ref.watch(avisosCobroProvider);
    final modo = ref.watch(temaProvider);
    final esPro = ref.watch(isProProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: LogoCuadra(size: 88)),
          ),
          const _Seccion('Mi negocio'),
          _Grupo(
            children: [
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: const Text('Nombre del negocio'),
                subtitle: Text(negocio?.nombre ?? 'Toca para ponerle nombre'),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _editarNombre(context, ref, negocio?.nombre ?? ''),
              ),
              const ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Moneda'),
                subtitle: Text(r'USD - Dólar ($)'),
              ),
            ],
          ),
          const _Seccion('Apariencia'),
          _Grupo(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Sistema'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Claro'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Oscuro'),
                    ),
                  ],
                  selected: {modo},
                  onSelectionChanged: (s) =>
                      ref.read(temaProvider.notifier).establecer(s.first),
                ),
              ),
            ],
          ),
          const _Seccion('Notificaciones'),
          _Grupo(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Avisos de cobro'),
                subtitle: const Text('Te avisamos cuando se acerca o vence un pago'),
                value: avisos,
                onChanged: (v) => _cambiarAvisos(ref, v),
              ),
            ],
          ),
          const _Seccion('Cuadra PRO'),
          _Grupo(
            children: [
              ListTile(
                leading: const Icon(Icons.workspace_premium, color: AppColors.pro),
                title: Text(esPro ? 'Cuadra PRO activo' : 'Cuadra PRO'),
                subtitle: Text(
                  esPro ? 'Gracias por tu suscripción' : 'Desbloquea todas las funciones',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/pro'),
              ),
            ],
          ),
          const _Seccion('Datos'),
          _Grupo(
            children: [
              ListTile(
                leading: const Icon(Icons.label_outline),
                title: const Text('Categorías'),
                subtitle: const Text('Administra las de ingresos y gastos'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ajustes/categorias'),
              ),
              ListTile(
                leading: const Icon(Icons.ios_share),
                title: const Text('Exportar reporte'),
                subtitle: const Text('Caja y préstamos en PDF'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ajustes/exportar'),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('Mis reportes'),
                subtitle: Text(
                  esPro ? 'PDF exportados en este celular' : 'Solo con Cuadra PRO',
                ),
                trailing: Icon(esPro ? Icons.chevron_right : Icons.lock_outline),
                onTap: () => context.push(esPro ? '/ajustes/reportes' : '/pro'),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Copia de seguridad'),
                subtitle: Text(
                  esPro ? 'Guarda o restaura todos tus datos' : 'Solo con Cuadra PRO',
                ),
                trailing: Icon(esPro ? Icons.chevron_right : Icons.lock_outline),
                onTap: () => context.push(esPro ? '/ajustes/respaldo' : '/pro'),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Borrar todos mis datos',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                subtitle: const Text('Elimina todo lo guardado en este celular'),
                onTap: () => confirmarYBorrarDatos(context, ref),
              ),
            ],
          ),
          const _Seccion('Ayuda'),
          _Grupo(
            children: [
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Compartir Cuadra'),
                subtitle: const Text('Recomiéndala a otro comerciante'),
                onTap: _compartirApp,
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Calificar la app'),
                subtitle: const Text('Tu opinión nos ayuda a mejorar'),
                onTap: () => _calificarApp(context),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Política de privacidad'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ajustes/privacidad'),
              ),
            ],
          ),
          const _Seccion('Acerca de'),
          _Grupo(
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Versión'),
                subtitle: Text(kVersionApp),
              ),
            ],
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
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
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

/// Tarjeta que agrupa varias filas de una sección, separadas por una línea.
class _Grupo extends StatelessWidget {
  const _Grupo({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            children[i],
          ],
        ],
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
