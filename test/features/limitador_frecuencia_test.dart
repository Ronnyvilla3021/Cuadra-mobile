import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/ads/limitador_frecuencia.dart';

void main() {
  test('no deja mostrar antes del intervalo y sí después', () {
    var ahora = DateTime(2026, 10, 5, 12, 0);
    final limitador = LimitadorFrecuencia(
      intervalo: const Duration(minutes: 5),
      reloj: () => ahora,
    );

    expect(limitador.puedeMostrar, isFalse); // recién iniciada la app

    ahora = DateTime(2026, 10, 5, 12, 4, 59);
    expect(limitador.puedeMostrar, isFalse);

    ahora = DateTime(2026, 10, 5, 12, 5);
    expect(limitador.puedeMostrar, isTrue);
  });

  test('al registrar, reinicia la cuenta', () {
    var ahora = DateTime(2026, 10, 5, 12, 0);
    final limitador = LimitadorFrecuencia(
      intervalo: const Duration(minutes: 5),
      reloj: () => ahora,
    );

    ahora = DateTime(2026, 10, 5, 12, 6);
    expect(limitador.puedeMostrar, isTrue);

    limitador.registrar();
    expect(limitador.puedeMostrar, isFalse);

    ahora = DateTime(2026, 10, 5, 12, 11);
    expect(limitador.puedeMostrar, isTrue);
  });
}
