/// Utilidades para manejar dinero como enteros en CENTAVOS.
///
/// Todo el dinero de la app se guarda como `int` (centavos):
/// $385.50 -> 38550. Así se evitan errores de redondeo de los decimales.
class Money {
  Money._();

  /// 38550 -> "$385.50"   |   -1250 -> "-$12.50"   |   123456789 -> "$1,234,567.89"
  static String format(int centavos, {String symbol = r'$'}) {
    final negativo = centavos < 0;
    final abs = centavos.abs();
    final enteros = abs ~/ 100;
    final resto = (abs % 100).toString().padLeft(2, '0');
    final miles = _agruparMiles(enteros.toString());
    return '${negativo ? '-' : ''}$symbol$miles.$resto';
  }

  /// Convierte lo que escribe el usuario en centavos.
  /// "12.5" -> 1250  |  "12,50" -> 1250  |  "0.05" -> 5
  /// Devuelve null si el texto no es un monto válido.
  static int? parse(String input) {
    final texto = input.trim().replaceAll(',', '.');
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(texto);
    if (match == null) return null;
    final enteros = int.parse(match.group(1)!);
    final decimales = (match.group(2) ?? '').padRight(2, '0');
    return enteros * 100 + int.parse(decimales);
  }

  static String _agruparMiles(String digitos) {
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      final restantes = digitos.length - i;
      buffer.write(digitos[i]);
      if (restantes > 1 && restantes % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}
