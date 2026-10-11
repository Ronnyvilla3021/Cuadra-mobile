import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/imagenes_app.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';

/// Pantalla de carga. Abre la base de datos y decide a dónde ir:
/// - sin negocio configurado -> /bienvenida
/// - con negocio             -> /inicio
///
/// Si la base de datos no abre en 10 s (o falla), muestra el error en lugar
/// de quedarse cargando para siempre.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _arrancar();
  }

  Future<void> _arrancar() async {
    try {
      // Siempre se lee de nuevo: si no, tras "Borrar todos mis datos" quedaría
      // guardado el negocio viejo y la app no pediría crear uno nuevo.
      ref.invalidate(negocioInicialProvider);
      // Espera la base de datos y un mínimo de 1.2 s para que se vea el splash.
      final resultados = await Future.wait<Object?>([
        ref
            .read(negocioInicialProvider.future)
            .timeout(const Duration(seconds: 10)),
        Future<void>.delayed(const Duration(milliseconds: 1200)),
      ]);
      if (!mounted) return;
      final negocio = resultados.first as Negocio?;
      context.go(negocio == null ? '/bienvenida' : '/inicio');
    } catch (e, st) {
      debugPrint('SPLASH ERROR: $e\n$st');
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _reintentar() {
    ref.invalidate(negocioInicialProvider);
    ref.invalidate(appDatabaseProvider);
    setState(() => _error = null);
    _arrancar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoCuadra(size: 112),
                const SizedBox(height: 24),
                const LetrasCuadra(alto: 48),
                const SizedBox(height: 8),
                const Text(
                  'Tu negocio, en tus manos',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                if (_error != null) ...[
                  const Text(
                    'No se pudo abrir tus datos.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 8),
                    SelectableText(
                      _error!,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _reintentar,
                    child: const Text('Reintentar'),
                  ),
                ] else
                  SizedBox(
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        minHeight: 4,
                        color: AppColors.primary,
                        backgroundColor: AppColors.navySurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
