import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../pro/pro_providers.dart';
import 'ad_config.dart';

/// Banner de tamaño fijo, sin espacio sobrante:
/// - Celular: 320x50 (ocupa exactamente 50 dp de alto).
/// - Tablet ancha (>= 728 dp): 728x90.
/// - No ocupa espacio hasta que el anuncio carga.
/// - No se muestra a usuarios PRO ni fuera de Android.
class AdBanner extends ConsumerStatefulWidget {
  const AdBanner({super.key});

  @override
  ConsumerState<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends ConsumerState<AdBanner> {
  BannerAd? _banner;
  bool _cargando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargar();
  }

  void _cargar() {
    if (!AdConfig.disponible || _cargando || ref.read(isProProvider)) return;

    final tamano = MediaQuery.sizeOf(context).width >= 728
        ? AdSize.leaderboard
        : AdSize.banner;
    if (_banner != null && _banner!.size.width == tamano.width) return;

    _cargando = true;
    BannerAd(
      adUnitId: AdConfig.bannerId,
      size: tamano,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _cargando = false;
          if (!mounted) {
            ad.dispose();
            return;
          }
          final anterior = _banner;
          setState(() => _banner = ad as BannerAd);
          _liberar(anterior);
        },
        onAdFailedToLoad: (ad, error) {
          _cargando = false;
          ad.dispose();
          debugPrint('AdMob: no se pudo cargar el banner: $error');
          // Reintenta en 1 minuto (por ejemplo, si no había internet).
          Future<void>.delayed(const Duration(minutes: 1), () {
            if (mounted) _cargar();
          });
        },
      ),
    ).load();
  }

  /// Libera un banner DESPUÉS del siguiente frame, para que el AdWidget
  /// viejo ya no lo esté usando.
  void _liberar(BannerAd? banner) {
    if (banner == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => banner.dispose());
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si el usuario pasa a PRO mientras usa la app, el anuncio desaparece.
    ref.listen<bool>(isProProvider, (anterior, esPro) {
      if (esPro) {
        final viejo = _banner;
        setState(() => _banner = null);
        _liberar(viejo);
      }
    });

    final banner = _banner;
    if (banner == null || ref.watch(isProProvider)) {
      return const SizedBox.shrink();
    }

    final ancho = banner.size.width.toDouble();
    final alto = banner.size.height.toDouble();

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: alto,
      child: SizedBox(width: ancho, height: alto, child: AdWidget(ad: banner)),
    );
  }
}
