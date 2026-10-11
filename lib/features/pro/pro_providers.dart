import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ajustes/tema_provider.dart';

const kClaveProActivo = 'pro_activo';
const kClaveProVerificado = 'pro_verificado_ms';

/// Estado PRO del usuario.
///
/// Arranca con lo último que Google Play confirmó (guardado en el celular, así
/// funciona sin internet). La suscripción real la actualiza FacturacionNotifier;
/// todo lo que sea PRO (candados, anuncios, exportación) ya pregunta aquí.
class ProNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(sharedPrefsProvider)?.getBool(kClaveProActivo) ?? false;

  /// Solo cambia el estado en memoria (lo usa el modo de prueba en debug).
  void establecer(bool esPro) => state = esPro;

  /// Estado confirmado por Google Play: se guarda para el próximo arranque.
  Future<void> fijar(bool esPro, {DateTime? ahora}) async {
    state = esPro;
    final prefs = ref.read(sharedPrefsProvider);
    await prefs?.setBool(kClaveProActivo, esPro);
    if (esPro) {
      await prefs?.setInt(
        kClaveProVerificado,
        (ahora ?? DateTime.now()).millisecondsSinceEpoch,
      );
    }
  }
}

final isProProvider = NotifierProvider<ProNotifier, bool>(ProNotifier.new);
