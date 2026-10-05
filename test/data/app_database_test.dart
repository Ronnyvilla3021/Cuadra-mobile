import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('siembra las 8 categorías predeterminadas', () async {
    final todas = await db.select(db.categorias).get();
    expect(todas.length, 8);
    expect(todas.every((c) => c.esPredeterminada), isTrue);
  });

  test('saldo = saldo inicial + ingresos - gastos', () async {
    await db.crearNegocio(nombre: 'Mi Tienda', saldoInicialCentavos: 10000);
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta',
      montoCentavos: 2500,
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.gasto,
      concepto: 'Transporte',
      montoCentavos: 1250,
    );

    expect(await db.watchSaldoCentavos().first, 11250);
  });

  test('sin negocio ni movimientos el saldo es 0', () async {
    expect(await db.watchSaldoCentavos().first, 0);
  });

  test('rechaza montos en cero o negativos', () async {
    await expectLater(
      db.registrarMovimiento(
        tipo: TipoMovimiento.ingreso,
        concepto: 'Inválido',
        montoCentavos: 0,
      ),
      throwsArgumentError,
    );
  });

  test('fiados: la deuda se calcula y el pago entra a la caja', () async {
    final clienteId = await db.crearCliente(nombre: 'Carlos');

    await db.registrarCompraFiado(clienteId: clienteId, montoCentavos: 2000);
    await db.registrarCompraFiado(clienteId: clienteId, montoCentavos: 1500);
    expect(await db.deudaClienteCentavos(clienteId), 3500);
    // Una compra fiada todavía no mueve la caja.
    expect(await db.watchSaldoCentavos().first, 0);

    await db.registrarPagoFiado(clienteId: clienteId, montoCentavos: 1000);
    expect(await db.deudaClienteCentavos(clienteId), 2500);
    // El pago sí entra a la caja como ingreso.
    expect(await db.watchSaldoCentavos().first, 1000);

    final movs = await db.select(db.movimientos).get();
    expect(movs.length, 1);
    expect(movs.first.origen, OrigenMovimiento.pagoFiado);
    expect(movs.first.categoriaId, isNotNull);
  });

  test('no permite pagar más de lo que se debe', () async {
    final clienteId = await db.crearCliente(nombre: 'María');
    await db.registrarCompraFiado(clienteId: clienteId, montoCentavos: 1000);

    await expectLater(
      db.registrarPagoFiado(clienteId: clienteId, montoCentavos: 5000),
      throwsStateError,
    );
    // Nada se guardó: deuda y caja siguen igual.
    expect(await db.deudaClienteCentavos(clienteId), 1000);
    expect(await db.watchSaldoCentavos().first, 0);
  });
}
