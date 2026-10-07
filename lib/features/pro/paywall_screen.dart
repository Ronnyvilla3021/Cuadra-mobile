import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'pro_providers.dart';

/// Pantalla de venta de Cuadra PRO.
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  static const _beneficios = [
    'Préstamos y alertas de cobro',
    'Empleados y pagos de personal',
    'Reportes y estadísticas avanzadas',
    'Exportación sin ver videos',
    'Copias de seguridad',
    'Sin publicidad',
  ];

  void _suscribirse(BuildContext context, WidgetRef ref) {
    final mensaje = ScaffoldMessenger.of(context);
    if (kDebugMode) {
      // Simulación SOLO para desarrollo. Nunca activa PRO en una app publicada.
      ref.read(isProProvider.notifier).establecer(true);
      mensaje.showSnackBar(
        const SnackBar(content: Text('Modo de prueba: PRO activado')),
      );
    } else {
      mensaje.showSnackBar(
        const SnackBar(
          content: Text('Las suscripciones estarán disponibles muy pronto.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final esPro = ref.watch(isProProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 64,
                    color: AppColors.pro,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cuadra PRO',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lleva el control completo de tu negocio.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  for (final b in _beneficios)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.income,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(b, style: textTheme.bodyLarge)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    r'$2.50 / mes',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: esPro ? null : () => _suscribirse(context, ref),
                    child: Text(esPro ? 'Ya eres PRO' : 'Suscribirme'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cancela cuando quieras',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                  if (kDebugMode && esPro)
                    TextButton(
                      onPressed: () =>
                          ref.read(isProProvider.notifier).establecer(false),
                      child: const Text('Desactivar PRO (solo debug)'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
