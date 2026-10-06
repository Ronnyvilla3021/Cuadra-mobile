import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../pro/pro_providers.dart';
import 'ad_config.dart';
import 'limitador_frecuencia.dart';

/// Anuncio de pantalla completa que se muestra DESPUÉS de guardar un
/// movimiento, como máximo una vez cada 5 minutos. Nunca antes ni durante
/// el registro, y nunca a usuarios PRO.
///
/// El reloj de los 5 minutos empieza al iniciar la app: durante los primeros
/// 5 minutos de uso no aparece ningún anuncio.
class InterstitialService {
  InterstitialService(this._ref);

  static const intervaloMinimo = Duration(minutes: 5);

  final Ref _ref;
  final _limitador = LimitadorFrecuencia(intervalo: intervaloMinimo);
  InterstitialAd? _anuncio;
  bool _cargando = false;

  /// Deja un anuncio listo para cuando toque mostrarlo.
  void precargar() {
    if (!AdConfig.disponible || _ref.read(isProProvider)) return;
    if (_anuncio != null || _cargando) return;

    _cargando = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _cargando = false;
          _anuncio = ad;
        },
        onAdFailedToLoad: (error) {
          _cargando = false;
          debugPrint('AdMob: no se pudo cargar el intersticial: $error');
        },
      ),
    );
  }

  /// Llamar justo después de guardar un movimiento.
  void mostrarSiCorresponde() {
    if (!AdConfig.disponible || _ref.read(isProProvider)) return;
    if (!_limitador.puedeMostrar) return;

    final anuncio = _anuncio;
    if (anuncio == null) {
      precargar();
      return;
    }

    _anuncio = null;
    anuncio.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        precargar();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        precargar();
      },
    );
    _limitador.registrar();
    anuncio.show();
  }

  void dispose() {
    _anuncio?.dispose();
    _anuncio = null;
  }
}

final interstitialProvider = Provider<InterstitialService>((ref) {
  final servicio = InterstitialService(ref);
  ref.onDispose(servicio.dispose);
  servicio.precargar();
  return servicio;
});
