import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/ads/ad_config.dart';
import 'features/ajustes/tema_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Se inicia en segundo plano para no retrasar el arranque de la app.
  if (AdConfig.disponible) {
    unawaited(MobileAds.instance.initialize());
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const CuadraApp(),
    ),
  );
}
