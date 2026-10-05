import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/caja_queries.dart';
import 'package:mi_negocio/data/database/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> sembrar() async {
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'A',
      montoCentavos: 100,
      fecha: DateTime(2026, 10, 1),
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.gasto,
      concepto: 'B',
      montoCentavos: 200,
      fecha: DateTime(2026, 10, 2),
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'C',
      montoCentavos: 300,
      fecha: DateTime(2026, 10, 3),
    );
  }

  test('ordena del más reciente al más antiguo', () async {
    await sembrar();
    final lista = await db.watchMovimientos().first;
    expect(lista.map((m) => m.concepto), ['C', 'B', 'A']);
  });

  test('filtra por tipo y respeta el límite', () async {
    await sembrar();
    final ingresos = await db.watchMovimientos(tipo: TipoMovimiento.ingreso).first;
    expect(ingresos.map((m) => m.concepto), ['C', 'A']);

    final uno = await db.watchMovimientos(limite: 1).first;
    expect(uno.single.concepto, 'C');
  });

  test('elimina movimientos manuales y recalcula el saldo', () async {
    await sembrar();
    final lista = await db.watchMovimientos().first;
    final c = lista.first; // ingreso de 300

    expect(await db.eliminarMovimientoManual(c.id), isTrue);
    // quedan +100 y -200
    expect(await db.watchSaldoCentavos().first, -100);
  });

  test('no elimina movimientos que vienen de un pago de fiado', () async {
    final clienteId = await db.crearCliente(nombre: 'Carlos');
    await db.registrarCompraFiado(clienteId: clienteId, montoCentavos: 1000);
    await db.registrarPagoFiado(clienteId: clienteId, montoCentavos: 400);

    final lista = await db.watchMovimientos().first;
    expect(await db.eliminarMovimientoManual(lista.single.id), isFalse);
    expect(await db.watchSaldoCentavos().first, 400);
  });
}
