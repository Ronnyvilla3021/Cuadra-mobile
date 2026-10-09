import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/reportes/periodo_reporte.dart';

void main() {
  // Viernes 9 de octubre de 2026.
  final hoy = DateTime(2026, 10, 9, 14, 30);

  test('hoy es un solo día', () {
    final r = rangoDePeriodo(PeriodoReporte.hoy, hoy);
    expect(r.desde, DateTime(2026, 10, 9));
    expect(r.hasta, DateTime(2026, 10, 9));
  });

  test('la semana empieza el lunes', () {
    final r = rangoDePeriodo(PeriodoReporte.semana, hoy);
    expect(r.desde, DateTime(2026, 10, 5));
    expect(r.hasta, DateTime(2026, 10, 9));
  });

  test('este mes va del día 1 hasta hoy', () {
    final r = rangoDePeriodo(PeriodoReporte.mes, hoy);
    expect(r.desde, DateTime(2026, 10, 1));
    expect(r.hasta, DateTime(2026, 10, 9));
  });

  test('mes pasado completo, también cruzando de año', () {
    final r = rangoDePeriodo(PeriodoReporte.mesPasado, hoy);
    expect(r.desde, DateTime(2026, 9, 1));
    expect(r.hasta, DateTime(2026, 9, 30));

    final enero = rangoDePeriodo(PeriodoReporte.mesPasado, DateTime(2027, 1, 15));
    expect(enero.desde, DateTime(2026, 12, 1));
    expect(enero.hasta, DateTime(2026, 12, 31));
  });

  test('personalizado usa las fechas elegidas sin la hora', () {
    final r = rangoDePeriodo(
      PeriodoReporte.personalizado,
      hoy,
      personalizado: RangoFechas(DateTime(2026, 8, 3, 10), DateTime(2026, 8, 20, 23)),
    );
    expect(r.desde, DateTime(2026, 8, 3));
    expect(r.hasta, DateTime(2026, 8, 20));
  });
}
