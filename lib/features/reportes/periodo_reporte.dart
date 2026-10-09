import '../../core/utils/fechas.dart';

enum PeriodoReporte {
  hoy('Hoy'),
  semana('Esta semana'),
  mes('Este mes'),
  mesPasado('Mes pasado'),
  personalizado('Elegir fechas');

  const PeriodoReporte(this.etiqueta);
  final String etiqueta;
}

/// Rango de días (ambos incluidos) de un período, en hora local.
class RangoFechas {
  const RangoFechas(this.desde, this.hasta);

  final DateTime desde;
  final DateTime hasta;
}

/// Calcula el rango de un período respecto a [hoy].
/// La semana empieza el lunes. Para [PeriodoReporte.personalizado] se usa
/// [personalizado]; si no hay, se toma el mes actual.
RangoFechas rangoDePeriodo(
  PeriodoReporte periodo,
  DateTime hoy, {
  RangoFechas? personalizado,
}) {
  final dia = soloDia(hoy);
  switch (periodo) {
    case PeriodoReporte.hoy:
      return RangoFechas(dia, dia);
    case PeriodoReporte.semana:
      final lunes = DateTime(dia.year, dia.month, dia.day - (dia.weekday - 1));
      return RangoFechas(lunes, dia);
    case PeriodoReporte.mes:
      return RangoFechas(DateTime(dia.year, dia.month, 1), dia);
    case PeriodoReporte.mesPasado:
      return RangoFechas(
        DateTime(dia.year, dia.month - 1, 1),
        DateTime(dia.year, dia.month, 0),
      );
    case PeriodoReporte.personalizado:
      if (personalizado != null) {
        return RangoFechas(
          soloDia(personalizado.desde),
          soloDia(personalizado.hasta),
        );
      }
      return RangoFechas(DateTime(dia.year, dia.month, 1), dia);
  }
}
