import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/caja_queries.dart';
import 'package:mi_negocio/data/database/prestamos_queries.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('si sale de la caja: baja al prestar y sube al cobrar', () async {
    await db.crearNegocio(nombre: 'Tienda', saldoInicialCentavos: 100000);
    final id = await db.crearPrestamo(
      nombrePersona: 'Carlos',
      montoCentavos: 30000,
      salioDeCaja: true,
    );
    expect(await db.watchSaldoCentavos().first, 70000);

    await db.registrarAbono(prestamoId: id, montoCentavos: 10000);
    expect(await db.watchSaldoCentavos().first, 80000);
  });

  test('si no sale de la caja, la caja no se mueve nunca', () async {
    await db.crearNegocio(nombre: 'Tienda', saldoInicialCentavos: 100000);
    final id = await db.crearPrestamo(
      nombrePersona: 'María',
      montoCentavos: 30000,
      salioDeCaja: false,
    );
    await db.registrarAbono(prestamoId: id, montoCentavos: 10000);

    expect(await db.watchSaldoCentavos().first, 100000);
    expect(await db.watchMovimientos().first, isEmpty);
  });

  test('estado: con deuda -> parcial -> pagado', () async {
    final id = await db.crearPrestamo(
      nombrePersona: 'José',
      montoCentavos: 10000,
      salioDeCaja: false,
    );
    Future<ResumenPrestamo> resumen() async =>
        (await db.watchResumenPrestamos().first).single;

    expect((await resumen()).estado, EstadoPrestamo.pendiente);

    await db.registrarAbono(prestamoId: id, montoCentavos: 3000);
    var r = await resumen();
    expect(r.estado, EstadoPrestamo.parcial);
    expect(r.pendienteCentavos, 7000);

    await db.registrarAbono(prestamoId: id, montoCentavos: 7000);
    r = await resumen();
    expect(r.estado, EstadoPrestamo.pagado);
    expect(r.pendienteCentavos, 0);
  });

  test('un pago mayor a lo pendiente se rechaza y no guarda nada', () async {
    await db.crearNegocio(nombre: 'Tienda', saldoInicialCentavos: 50000);
    final id = await db.crearPrestamo(
      nombrePersona: 'Ana',
      montoCentavos: 1000,
      salioDeCaja: true,
    );
    await expectLater(
      db.registrarAbono(prestamoId: id, montoCentavos: 99999),
      throwsStateError,
    );
    expect(await db.watchAbonos(id).first, isEmpty);
    expect(await db.watchSaldoCentavos().first, 49000);
  });

  test('reutiliza a la persona aunque cambien mayúsculas y espacios', () async {
    await db.crearPrestamo(
      nombrePersona: 'carlos',
      montoCentavos: 100,
      salioDeCaja: false,
    );
    await db.crearPrestamo(
      nombrePersona: ' Carlos ',
      telefono: '0991234567',
      montoCentavos: 200,
      salioDeCaja: false,
    );
    final personas = await db.select(db.clientes).get();
    expect(personas.length, 1);
    expect(personas.single.telefono, '0991234567');
  });

  test('la fecha de pago no puede ser anterior al préstamo', () async {
    await expectLater(
      db.crearPrestamo(
        nombrePersona: 'Luis',
        montoCentavos: 100,
        salioDeCaja: false,
        fechaPrestamo: DateTime(2026, 5, 10),
        fechaVencimiento: DateTime(2026, 5, 1),
      ),
      throwsArgumentError,
    );
  });

  test('detecta préstamos vencidos y deja de estarlo al pagarse', () async {
    final id = await db.crearPrestamo(
      nombrePersona: 'Pedro',
      montoCentavos: 5000,
      salioDeCaja: false,
      fechaPrestamo: DateTime(2026, 1, 1),
      fechaVencimiento: DateTime(2026, 1, 31),
    );
    var r = (await db.watchResumenPrestamos().first).single;
    expect(r.estaVencido(DateTime(2026, 2, 1)), isTrue);
    expect(r.estaVencido(DateTime(2026, 1, 31)), isFalse);

    await db.registrarAbono(prestamoId: id, montoCentavos: 5000);
    r = (await db.watchResumenPrestamos().first).single;
    expect(r.estaVencido(DateTime(2026, 2, 1)), isFalse);
  });

  test('eliminar un préstamo revierte la caja', () async {
    await db.crearNegocio(nombre: 'Tienda', saldoInicialCentavos: 100000);
    final id = await db.crearPrestamo(
      nombrePersona: 'Rosa',
      montoCentavos: 30000,
      salioDeCaja: true,
    );
    await db.registrarAbono(prestamoId: id, montoCentavos: 10000);
    expect(await db.watchSaldoCentavos().first, 80000);

    await db.eliminarPrestamo(id);
    expect(await db.watchSaldoCentavos().first, 100000);
    expect(await db.watchResumenPrestamos().first, isEmpty);
    expect(await db.watchMovimientos().first, isEmpty);
  });
}
