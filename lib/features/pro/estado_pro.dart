/// Cuánto tiempo se mantiene PRO sin poder confirmarlo con Google Play
/// (por ejemplo, sin internet). Después se desactiva hasta verificar de nuevo.
const kGraciaPro = Duration(days: 3);

/// Decide si el usuario debe seguir siendo PRO.
///
/// - [compraActiva]: Google Play reportó una suscripción vigente.
/// - [tiendaRespondio]: la tienda contestó (con o sin compra). Si es false, no
///   se pudo verificar (sin internet, Play no disponible, etc.).
/// - [cacheado] / [ultimaVerificacion]: lo último que se guardó en el celular.
bool decidirPro({
  required bool compraActiva,
  required bool tiendaRespondio,
  required bool cacheado,
  required DateTime? ultimaVerificacion,
  required DateTime ahora,
  Duration gracia = kGraciaPro,
}) {
  if (compraActiva) return true;
  if (tiendaRespondio) return false;
  // Sin poder verificar: se respeta lo guardado, pero solo por un tiempo.
  if (!cacheado || ultimaVerificacion == null) return false;
  return ahora.difference(ultimaVerificacion) <= gracia;
}
