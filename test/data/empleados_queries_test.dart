import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/empleados_queries.dart';
import 'package:mi_negocio/data/database/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('calcula tarifa x unidades + bono - deducción', () {
    expect(
      calcularTotalPago(tarifaCentavos: 1250, unidades: 8),
      10000,
    );
    expect(
      calcularTotalPago(
        tarifaCentavos: 1000,
        unidades: 7.5,
        bonificacionCentavos: 500,
        deduccionCentavos: 200,
      ),
      7800,
    );
  });

  test('un pago crea el gasto en la caja y borrarlo lo revierte', () async {
    final id = await db.crearEmpleado(
      nombre: ' Luis ',
      tipoPago: TipoPago.dia,
      tarifaCentavos: 2000,
    );

    final pagoId = await db.registrarPagoEmpleado(
      empleadoId: id,
      unidades: 5,
      bonificacionCentavos: 1000,
      deduccionCentavos: 500,
      nota: ' semana 1 ',
    );

    var movs = await db.select(db.movimientos).get();
    expect(movs.length, 1);
    expect(movs.single.tipo, TipoMovimiento.gasto);
    expect(movs.single.origen, OrigenMovimiento.pagoEmpleado);
    expect(movs.single.origenId, pagoId);
    expect(movs.single.montoCentavos, 10500);
    expect(movs.single.concepto, 'Pago a Luis');

    final resumen = (await db.watchResumenEmpleados().first).single;
    expect(resumen.empleado.nombre, 'Luis');
    expect(resumen.pagadoMesCentavos, 10500);
    expect(resumen.pagadoTotalCentavos, 10500);
    expect(resumen.ultimoPago, isNotNull);

    final pago = (await db.watchPagosEmpleado(id).first).single;
    expect(pago.nota, 'semana 1');
    expect(pago.tarifaAplicadaCentavos, 2000);

    await db.eliminarPagoEmpleado(pagoId);
    movs = await db.select(db.movimientos).get();
    expect(movs, isEmpty);
    expect(await db.watchPagosEmpleado(id).first, isEmpty);
  });

  test('rechaza pagos con total cero o negativo', () async {
    final id = await db.crearEmpleado(
      nombre: 'Ana',
      tipoPago: TipoPago.hora,
      tarifaCentavos: 500,
    );
    expect(
      () => db.registrarPagoEmpleado(
        empleadoId: id,
        unidades: 1,
        deduccionCentavos: 900,
      ),
      throwsArgumentError,
    );
    expect(await db.select(db.movimientos).get(), isEmpty);
  });

  test('cambiar la tarifa no altera pagos anteriores y quitar oculta', () async {
    final id = await db.crearEmpleado(
      nombre: 'Marta',
      tipoPago: TipoPago.mes,
      tarifaCentavos: 40000,
    );
    await db.registrarPagoEmpleado(empleadoId: id, unidades: 1);
    await db.actualizarEmpleado(
      id,
      nombre: 'Marta',
      tipoPago: TipoPago.mes,
      tarifaCentavos: 45000,
    );

    final pago = (await db.watchPagosEmpleado(id).first).single;
    expect(pago.tarifaAplicadaCentavos, 40000);
    expect(pago.totalPagadoCentavos, 40000);

    await db.desactivarEmpleado(id);
    expect(await db.watchResumenEmpleados().first, isEmpty);
    expect(await db.select(db.pagosEmpleado).get().then((l) => l.length), 1);
  });
}
