import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';

/// Convierte un teléfono escrito a mano al formato que pide WhatsApp
/// (solo dígitos, con código de país). Devuelve null si no parece válido.
///
/// - "0991234567"       -> "593991234567"  (se asume Ecuador)
/// - "+1 305 555 0100"  -> "13055550100"   (ya trae su código de país)
/// - "00593991234567"   -> "593991234567"
String? telefonoParaWhatsapp(String crudo, {String codigoPais = '593'}) {
  final texto = crudo.trim();
  var digitos = texto.replaceAll(RegExp(r'\D'), '');
  if (digitos.isEmpty) return null;

  if (texto.startsWith('+')) {
    // Ya incluye el código de país.
  } else if (digitos.startsWith('00')) {
    digitos = digitos.substring(2);
  } else if (digitos.startsWith('0')) {
    digitos = codigoPais + digitos.substring(1);
  } else if (digitos.length <= 10) {
    digitos = codigoPais + digitos;
  }
  return (digitos.length >= 8 && digitos.length <= 15) ? digitos : null;
}

/// Mensaje de recordatorio de pago, listo para enviar por WhatsApp.
String mensajeRecordatorio({
  required String nombre,
  required int pendienteCentavos,
  required DateTime? vencimiento,
  required DateTime ahora,
  String? negocio,
}) {
  final primero = nombre.trim().split(RegExp(r'\s+')).first;
  final monto = Money.format(pendienteCentavos);

  final String cuerpo;
  if (vencimiento == null) {
    cuerpo = 'te recuerdo que tienes un pago pendiente de $monto.';
  } else {
    // Se comparan fechas en UTC para que el horario de verano no altere el conteo.
    final dias = DateTime.utc(vencimiento.year, vencimiento.month, vencimiento.day)
        .difference(DateTime.utc(ahora.year, ahora.month, ahora.day))
        .inDays;
    final fecha = fechaCorta(vencimiento);
    if (dias < 0) {
      cuerpo = 'te recuerdo que tu pago de $monto venció el $fecha.';
    } else if (dias == 0) {
      cuerpo = 'te recuerdo que hoy vence tu pago de $monto.';
    } else if (dias == 1) {
      cuerpo = 'te recuerdo que mañana ($fecha) vence tu pago de $monto.';
    } else {
      cuerpo = 'te recuerdo que el $fecha vence tu pago de $monto.';
    }
  }

  final nombreNegocio = (negocio ?? '').trim();
  final cierre = nombreNegocio.isEmpty ? '¡Gracias!' : '¡Gracias! — $nombreNegocio';
  return 'Hola $primero, $cuerpo $cierre';
}

/// Enlace que abre el chat de WhatsApp con el mensaje ya escrito.
Uri enlaceWhatsapp(String telefono, String mensaje) {
  return Uri.parse('https://wa.me/$telefono?text=${Uri.encodeComponent(mensaje)}');
}

/// Abre WhatsApp (o el navegador si no está instalado). false si no se pudo.
Future<bool> abrirWhatsapp(Uri enlace) async {
  try {
    return await launchUrl(enlace, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
