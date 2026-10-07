import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferencias guardadas en el celular. Es null en las pruebas automáticas;
/// en la app real se completa en main.dart.
final sharedPrefsProvider = Provider<SharedPreferences?>((ref) => null);

/// Tema de la app: sigue al sistema, o claro u oscuro por elección del usuario.
class TemaNotifier extends Notifier<ThemeMode> {
  static const _clave = 'tema';

  @override
  ThemeMode build() {
    final valor = ref.watch(sharedPrefsProvider)?.getString(_clave);
    return switch (valor) {
      'claro' => ThemeMode.light,
      'oscuro' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> establecer(ThemeMode modo) async {
    state = modo;
    final texto = switch (modo) {
      ThemeMode.light => 'claro',
      ThemeMode.dark => 'oscuro',
      ThemeMode.system => 'sistema',
    };
    await ref.read(sharedPrefsProvider)?.setString(_clave, texto);
  }
}

final temaProvider = NotifierProvider<TemaNotifier, ThemeMode>(
  TemaNotifier.new,
);
