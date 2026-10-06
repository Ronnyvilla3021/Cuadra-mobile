import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/dashboard_queries.dart';
import 'package:mi_negocio/data/database/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('el resumen solo cuenta los movimientos del día', () async {
    final ahora = DateTime.now();
    final ayer = ahora.subtract(const Duration(days: 1));

    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta hoy',
      montoCentavos: 50000,
      fecha: ahora,
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Otra venta hoy',
      montoCentavos: 2000,
      fecha: ahora,
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.gasto,
      concepto: 'Compra hoy',
      montoCentavos: 13450,
      fecha: ahora,
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta de ayer',
      montoCentavos: 99900,
      fecha: ayer,
    );

    final r = await db.watchResumenDia().first;
    expect(r.ingresosCentavos, 52000);
    expect(r.gastosCentavos, 13450);
    expect(r.gananciaCentavos, 38550);
  });

  test('sin movimientos, todo es cero', () async {
    final r = await db.watchResumenDia().first;
    expect(r.ingresosCentavos, 0);
    expect(r.gastosCentavos, 0);
    expect(r.gananciaCentavos, 0);
  });
}
