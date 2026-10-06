import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado PRO del usuario.
///
/// PROVISIONAL: arranca en false y solo se puede activar a mano en modo debug
/// (desde la pantalla PRO). Cuando se conecte Google Play Billing, el valor
/// vendrá de la suscripción real y el resto del código no cambia: todo lo que
/// sea PRO (candados, anuncios, exportación) ya pregunta aquí.
class ProNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void establecer(bool esPro) => state = esPro;
}

final isProProvider = NotifierProvider<ProNotifier, bool>(ProNotifier.new);
