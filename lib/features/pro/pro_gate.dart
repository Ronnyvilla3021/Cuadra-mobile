import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'pro_providers.dart';

/// Envuelve una función PRO. Si el usuario es PRO muestra [child];
/// si no, muestra una pantalla con candado y el botón para desbloquear.
class ProGate extends ConsumerWidget {
  const ProGate({
    super.key,
    required this.titulo,
    required this.icono,
    required this.descripcion,
    required this.funciones,
    required this.child,
  });

  final String titulo;
  final IconData icono;
  final String descripcion;

  /// Pequeño adelanto de lo que incluye (ícono + nombre).
  final List<(IconData, String)> funciones;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isProProvider)) return child;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(icono, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.pro.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.pro.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.lock, color: AppColors.pro, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Función disponible en Cuadra PRO',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context.push('/pro'),
                        child: const Text('Desbloquear ahora'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final f in funciones)
                      Column(
                        children: [
                          Icon(f.$1, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(height: 6),
                          Text(f.$2, style: textTheme.labelSmall),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
