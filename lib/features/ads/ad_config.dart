import 'dart:io' show Platform;

/// Configuración de AdMob.
///
/// Mientras desarrollamos se usan los IDs de PRUEBA oficiales de Google:
/// muestran anuncios de ejemplo y nunca generan dinero ni riesgo de bloqueo.
/// Para publicar, los IDs reales se pasan al compilar:
///   flutter build appbundle \
///     --dart-define=ADMOB_BANNER_ID=ca-app-pub-XXXX/AAAA \
///     --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-XXXX/BBBB \
///     --dart-define=ADMOB_REWARDED_ID=ca-app-pub-XXXX/CCCC
/// (y se cambia el ID de aplicación en AndroidManifest.xml).
class AdConfig {
  AdConfig._();

  static const bannerId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );

  static const interstitialId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
    defaultValue: 'ca-app-pub-3940256099942544/1033173712',
  );

  static const rewardedId = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
    defaultValue: 'ca-app-pub-3940256099942544/5224354917',
  );

  /// Solo hay anuncios en Android (y no en las pruebas automáticas del PC).
  static bool get disponible => Platform.isAndroid;
}
