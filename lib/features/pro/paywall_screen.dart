import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/imagenes_app.dart';
import 'facturacion.dart';
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
    final facturacion = ref.read(facturacionProvider);
    if (facturacion.producto == null && kDebugMode) {
      // Simulación SOLO para desarrollo, cuando Google Play aún no conoce el
      // producto. Nunca activa PRO en una app publicada.
      ref.read(isProProvider.notifier).establecer(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modo de prueba: PRO activado')),
      );
      return;
    }
    ref.read(facturacionProvider.notifier).comprar();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final esPro = ref.watch(isProProvider);
    final facturacion = ref.watch(facturacionProvider);
    final precio = facturacion.producto == null
        ? r'$2.50 / mes'
        : '${facturacion.producto!.price} / mes';

    // Esta pantalla siempre es oscura y es la única con «fondo_pro.jpg».
    return Theme(
      data: AppTheme.dark,
      child: FondoImagen(
        ruta: kFondoPro,
        colorVelo: Colors.black,
        opacidadVelo: kVeloFondoPro,
        colorRespaldo: const Color(0xFF0B1330),
        child: _contenido(context, ref, textTheme, esPro, facturacion, precio),
      ),
    );
  }

  Widget _contenido(
    BuildContext context,
    WidgetRef ref,
    TextTheme textTheme,
    bool esPro,
    EstadoFacturacion facturacion,
    String precio,
  ) {
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
                  const Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        LogoCuadra(size: 96),
                        Positioned(
                          right: -6,
                          bottom: -6,
                          child: Icon(
                            Icons.workspace_premium,
                            size: 34,
                            color: AppColors.pro,
                          ),
                        ),
                      ],
                    ),
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
                    precio,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: (esPro || facturacion.cargando)
                        ? null
                        : () => _suscribirse(context, ref),
                    child: facturacion.cargando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(esPro ? 'Ya eres PRO' : 'Suscribirme'),
                  ),
                  if (facturacion.mensaje != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      facturacion.mensaje!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                  if (!esPro)
                    TextButton(
                      onPressed: facturacion.cargando
                          ? null
                          : () => ref.read(facturacionProvider.notifier).restaurar(),
                      child: const Text('Restaurar compras'),
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
