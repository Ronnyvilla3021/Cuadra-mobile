import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'features/ads/ad_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Se inicia en segundo plano para no retrasar el arranque de la app.
  if (AdConfig.disponible) {
    unawaited(MobileAds.instance.initialize());
  }

  runApp(const ProviderScope(child: CuadraApp()));
}
