import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/core/utils/money.dart';

void main() {
  group('Money.format', () {
    test('formatea centavos como dólares', () {
      expect(Money.format(38550), r'$385.50');
      expect(Money.format(0), r'$0.00');
      expect(Money.format(5), r'$0.05');
      expect(Money.format(100), r'$1.00');
    });

    test('agrupa miles', () {
      expect(Money.format(123456789), r'$1,234,567.89');
      expect(Money.format(100000), r'$1,000.00');
      expect(Money.format(99999), r'$999.99');
    });

    test('maneja negativos', () {
      expect(Money.format(-1250), r'-$12.50');
    });
  });

  group('Money.parse', () {
    test('convierte texto válido a centavos', () {
      expect(Money.parse('12.5'), 1250);
      expect(Money.parse('12,50'), 1250);
      expect(Money.parse('0.05'), 5);
      expect(Money.parse('100'), 10000);
      expect(Money.parse(' 7.25 '), 725);
    });

    test('devuelve null si no es válido', () {
      expect(Money.parse(''), isNull);
      expect(Money.parse('abc'), isNull);
      expect(Money.parse('12.555'), isNull);
      expect(Money.parse('-5'), isNull);
    });
  });
}
