import 'package:drift/drift.dart';

import 'app_database.dart';
import 'enums.dart';

/// Totales de un día. Ventas = ingresos del día; ganancia = ingresos - gastos.
class ResumenDia {
  const ResumenDia({
    required this.ingresosCentavos,
    required this.gastosCentavos,
  });

  final int ingresosCentavos;
  final int gastosCentavos;

  int get gananciaCentavos => ingresosCentavos - gastosCentavos;
}

extension DashboardQueries on AppDatabase {
  /// Resumen del día indicado (por defecto, hoy), en hora local.
  Stream<ResumenDia> watchResumenDia({DateTime? dia}) {
    final base = dia ?? DateTime.now();
    final inicio = DateTime(base.year, base.month, base.day);
    final fin = DateTime(base.year, base.month, base.day + 1);

    final query = select(movimientos)
      ..where(
        (m) =>
            m.fecha.isBiggerOrEqualValue(inicio) &
            m.fecha.isSmallerThanValue(fin),
      );

    return query.watch().map((filas) {
      var ingresos = 0;
      var gastos = 0;
      for (final m in filas) {
        if (m.tipo == TipoMovimiento.ingreso) {
          ingresos += m.montoCentavos;
        } else {
          gastos += m.montoCentavos;
        }
      }
      return ResumenDia(ingresosCentavos: ingresos, gastosCentavos: gastos);
    });
  }
}
