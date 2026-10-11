import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/pro/estado_pro.dart';

void main() {
  final ahora = DateTime(2026, 10, 9, 12);

  bool decidir({
    bool compra = false,
    bool respondio = false,
    bool cache = false,
    DateTime? ultima,
  }) =>
      decidirPro(
        compraActiva: compra,
        tiendaRespondio: respondio,
        cacheado: cache,
        ultimaVerificacion: ultima,
        ahora: ahora,
      );

  test('con suscripción activa siempre es PRO', () {
    expect(decidir(compra: true, respondio: true), isTrue);
    expect(decidir(compra: true), isTrue);
  });

  test('si Google Play contesta que no hay suscripción, deja de ser PRO', () {
    expect(
      decidir(respondio: true, cache: true, ultima: ahora.subtract(const Duration(hours: 1))),
      isFalse,
    );
  });

  test('sin poder verificar, mantiene PRO solo durante la gracia', () {
    expect(
      decidir(cache: true, ultima: ahora.subtract(const Duration(days: 2))),
      isTrue,
    );
    expect(
      decidir(cache: true, ultima: ahora.subtract(const Duration(days: 4))),
      isFalse,
    );
  });

  test('sin datos guardados no es PRO', () {
    expect(decidir(), isFalse);
    expect(decidir(cache: true), isFalse);
  });
}
