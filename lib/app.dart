import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/widgets/imagenes_app.dart';
import 'core/theme/app_theme.dart';
import 'features/ads/ad_config.dart';
import 'features/alertas/servicio_alertas.dart';
import 'features/pro/facturacion.dart';
import 'features/prestamos/prestamos_providers.dart';
import 'features/ajustes/tema_provider.dart';

class CuadraApp extends ConsumerWidget {
  const CuadraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Cobro de PRO con Google Play: se conecta al abrir la app (solo Android).
    if (AdConfig.disponible) ref.read(facturacionProvider);

    // Avisos de cobro en el celular del dueño: se reprograman cada vez que
    // cambian los préstamos o el interruptor de avisos. Solo en Android.
    if (AdConfig.disponible) {
      final alertas = ref.read(servicioAlertasProvider);
      ref.listen(resumenPrestamosProvider, (anterior, siguiente) {
        final lista = siguiente.value;
        if (lista != null) {
          alertas.sincronizar(lista, activos: ref.read(avisosCobroProvider));
        }
      });
      ref.listen(avisosCobroProvider, (anterior, activos) {
        final lista = ref.read(resumenPrestamosProvider).value;
        if (lista != null) alertas.sincronizar(lista, activos: activos);
      });
    }

    return MaterialApp.router(
      title: 'Cuadra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(temaProvider),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es'), Locale('en')],
      routerConfig: router,
      builder: (context, child) => FondoApp(child: child),
    );
  }
}
