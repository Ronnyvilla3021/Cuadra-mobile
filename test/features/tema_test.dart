import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/ajustes/tema_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('el tema se guarda y se recupera', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final c1 = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(c1.dispose);

    expect(c1.read(temaProvider), ThemeMode.system);
    await c1.read(temaProvider.notifier).establecer(ThemeMode.dark);
    expect(c1.read(temaProvider), ThemeMode.dark);
    expect(prefs.getString('tema'), 'oscuro');

    // Simula abrir la app otra vez.
    final c2 = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(c2.dispose);
    expect(c2.read(temaProvider), ThemeMode.dark);
  });
}
