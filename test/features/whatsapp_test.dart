import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/prestamos/whatsapp.dart';

void main() {
  group('telefonoParaWhatsapp', () {
    test('agrega el código de Ecuador a números locales', () {
      expect(telefonoParaWhatsapp('0991234567'), '593991234567');
      expect(telefonoParaWhatsapp('991234567'), '593991234567');
      expect(telefonoParaWhatsapp('022345678'), '59322345678');
    });

    test('respeta números que ya traen código de país', () {
      expect(telefonoParaWhatsapp('+593 99 123 4567'), '593991234567');
      expect(telefonoParaWhatsapp('+1 305 555 0100'), '13055550100');
      expect(telefonoParaWhatsapp('00593991234567'), '593991234567');
      expect(telefonoParaWhatsapp('593991234567'), '593991234567');
    });

    test('rechaza números inválidos', () {
      expect(telefonoParaWhatsapp(''), isNull);
      expect(telefonoParaWhatsapp('abc'), isNull);
      expect(telefonoParaWhatsapp('12'), isNull);
    });
  });

  group('mensajeRecordatorio', () {
    final ahora = DateTime(2026, 10, 14, 12);

    String mensaje({DateTime? vence, String? negocio, String nombre = 'Carlos'}) {
      return mensajeRecordatorio(
        nombre: nombre,
        pendienteCentavos: 7000,
        vencimiento: vence,
        ahora: ahora,
        negocio: negocio,
      );
    }

    test('vence mañana', () {
      expect(
        mensaje(vence: DateTime(2026, 10, 15)),
        'Hola Carlos, te recuerdo que mañana (15/10/2026) vence tu pago de \$70.00. ¡Gracias!',
      );
    });

    test('vence hoy', () {
      expect(
        mensaje(vence: DateTime(2026, 10, 14)),
        'Hola Carlos, te recuerdo que hoy vence tu pago de \$70.00. ¡Gracias!',
      );
    });

    test('vence más adelante', () {
      expect(
        mensaje(vence: DateTime(2026, 10, 30)),
        'Hola Carlos, te recuerdo que el 30/10/2026 vence tu pago de \$70.00. ¡Gracias!',
      );
    });

    test('ya venció', () {
      expect(
        mensaje(vence: DateTime(2026, 10, 10)),
        'Hola Carlos, te recuerdo que tu pago de \$70.00 venció el 10/10/2026. ¡Gracias!',
      );
    });

    test('sin fecha de pago', () {
      expect(
        mensaje(),
        'Hola Carlos, te recuerdo que tienes un pago pendiente de \$70.00. ¡Gracias!',
      );
    });

    test('usa el primer nombre y firma con el negocio', () {
      final m = mensaje(nombre: 'Carlos Pérez', negocio: 'Mi Tienda');
      expect(m, startsWith('Hola Carlos,'));
      expect(m, endsWith('¡Gracias! — Mi Tienda'));
    });
  });

  test('el enlace de WhatsApp lleva el mensaje codificado', () {
    final uri = enlaceWhatsapp('593991234567', 'Hola Carlos, ¿cómo estás? 100%');

    expect(uri.host, 'wa.me');
    expect(uri.path, '/593991234567');
    expect(uri.queryParameters['text'], 'Hola Carlos, ¿cómo estás? 100%');
  });
}
