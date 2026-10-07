import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ajustes/tema_provider.dart';

/// 12345 -> "123.45" (para rellenar campos de texto).
String montoPlano(int centavos) =>
    '${centavos ~/ 100}.${(centavos % 100).toString().padLeft(2, '0')}';

/// Ajustes propios del usuario para los préstamos.
class AjustesPrestamos {
  const AjustesPrestamos({this.salenDeCaja = true, this.limiteCentavos});

  /// Valor inicial del interruptor "sale de la caja" en cada préstamo nuevo.
  final bool salenDeCaja;

  /// Límite del total pendiente de cobro (null = sin límite).
  final int? limiteCentavos;
}

class AjustesPrestamosNotifier extends Notifier<AjustesPrestamos> {
  static const _kSalen = 'prestamos_salen_de_caja';
  static const _kLimite = 'prestamos_limite_centavos';

  @override
  AjustesPrestamos build() {
    final p = ref.watch(sharedPrefsProvider);
    return AjustesPrestamos(
      salenDeCaja: p?.getBool(_kSalen) ?? true,
      limiteCentavos: p?.getInt(_kLimite),
    );
  }

  Future<void> guardar({required bool salenDeCaja, int? limiteCentavos}) async {
    state = AjustesPrestamos(
      salenDeCaja: salenDeCaja,
      limiteCentavos: limiteCentavos,
    );
    final p = ref.read(sharedPrefsProvider);
    await p?.setBool(_kSalen, salenDeCaja);
    if (limiteCentavos == null) {
      await p?.remove(_kLimite);
    } else {
      await p?.setInt(_kLimite, limiteCentavos);
    }
  }
}

final ajustesPrestamosProvider =
    NotifierProvider<AjustesPrestamosNotifier, AjustesPrestamos>(
  AjustesPrestamosNotifier.new,
);
