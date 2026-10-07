/// Fecha sin la hora (medianoche local).
DateTime soloDia(DateTime d) => DateTime(d.year, d.month, d.day);

/// 05/10/2026
String fechaCorta(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// "Vence hoy", "Vence mañana", "Vence en 5 días", "Venció hace 3 días".
String textoVencimiento(DateTime vencimiento, DateTime hoy) {
  final dias = soloDia(vencimiento).difference(soloDia(hoy)).inDays;
  if (dias == 0) return 'Vence hoy';
  if (dias == 1) return 'Vence mañana';
  if (dias > 1) return 'Vence en $dias días';
  if (dias == -1) return 'Venció ayer';
  return 'Venció hace ${-dias} días';
}
