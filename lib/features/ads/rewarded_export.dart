import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../pro/pro_providers.dart';
import 'ad_config.dart';

/// Carga y muestra un video con recompensa.
/// Devuelve true solo si el usuario lo vio completo.
Future<bool> _mostrarVideoConRecompensa() {
  final resultado = Completer<bool>();
  var mostrando = false;

  RewardedAd.load(
    adUnitId: AdConfig.rewardedId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        if (resultado.isCompleted) {
          ad.dispose(); // llegó tarde: ya dimos por perdida la carga
          return;
        }
        mostrando = true;
        var gano = false;
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (anuncio) {
            anuncio.dispose();
            if (!resultado.isCompleted) resultado.complete(gano);
          },
          onAdFailedToShowFullScreenContent: (anuncio, error) {
            anuncio.dispose();
            if (!resultado.isCompleted) resultado.complete(false);
          },
        );
        ad.show(
          onUserEarnedReward: (anuncio, recompensa) {
            gano = true;
          },
        );
      },
      onAdFailedToLoad: (error) {
        debugPrint('AdMob: no se pudo cargar el video: $error');
        if (!resultado.isCompleted) resultado.complete(false);
      },
    ),
  );

  // Solo se limita la espera de la CARGA. Cuando el video ya empezó,
  // el usuario puede verlo el tiempo que dure.
  Timer(const Duration(seconds: 20), () {
    if (!mostrando && !resultado.isCompleted) resultado.complete(false);
  });

  return resultado.future;
}

/// Devuelve true si el usuario puede exportar un reporte ahora mismo:
/// - PRO: siempre, sin video.
/// - Gratis: solo después de ver un video con recompensa.
///
/// Llamarla justo antes de generar el PDF/Excel.
Future<bool> desbloquearExportacion(BuildContext context, WidgetRef ref) async {
  if (ref.read(isProProvider) || !AdConfig.disponible) return true;

  final quiereVer = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Exportar reporte'),
      content: const Text(
        'Mira un video corto para exportar gratis.\n'
        'Con Cuadra PRO exportas sin anuncios.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Ver video'),
        ),
      ],
    ),
  );
  if (quiereVer != true || !context.mounted) return false;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );

  final gano = await _mostrarVideoConRecompensa();

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop(); // cierra el cargando
    if (!gano) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Para exportar, mira el video completo. Inténtalo de nuevo.'),
        ),
      );
    }
  }
  return gano;
}
