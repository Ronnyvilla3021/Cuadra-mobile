import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/empleados_queries.dart';
import 'package:mi_negocio/data/database/enums.dart';
import 'package:mi_negocio/data/database/prestamos_queries.dart';
import 'package:mi_negocio/data/database/respaldo_queries.dart';

void main() {
  // La prueba abre dos bases en memoria a propósito.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late Directory carpeta;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    carpeta = Directory.systemTemp.createTempSync('cuadra_test_');
  });
  tearDown(() async {
    await db.close();
    if (carpeta.existsSync()) carpeta.deleteSync(recursive: true);
  });

  Future<void> llenar(AppDatabase d) async {
    await d.crearNegocio(nombre: 'Tienda Ronny', saldoInicialCentavos: 5000);
    await d.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta',
      montoCentavos: 1000,
    );
    final p = await d.crearPrestamo(
      nombrePersona: 'Ana',
      montoCentavos: 2000,
      salioDeCaja: true,
    );
    await d.registrarAbono(prestamoId: p, montoCentavos: 500);
    final e = await d.crearEmpleado(
      nombre: 'Luis',
      tipoPago: TipoPago.dia,
      tarifaCentavos: 2000,
    );
    await d.registrarPagoEmpleado(empleadoId: e, unidades: 2);
  }

  test('crea una copia y la restaura en otra base con los mismos datos', () async {
    await llenar(db);
    final copia = await db.crearRespaldo(carpeta);
    expect(copia.path.endsWith('.cuadra'), isTrue);
    expect(copia.lengthSync(), greaterThan(0));

    final otra = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(otra.close);
    await otra.crearNegocio(nombre: 'Otro negocio');
    await otra.registrarMovimiento(
      tipo: TipoMovimiento.gasto,
      concepto: 'Se perderá',
      montoCentavos: 77,
    );

    await otra.restaurarRespaldo(copia);

    expect((await otra.negocioActual())!.nombre, 'Tienda Ronny');
    expect(await otra.select(otra.movimientos).get().then((l) => l.length),
        await db.select(db.movimientos).get().then((l) => l.length));
    expect(await otra.select(otra.prestamos).get().then((l) => l.length), 1);
    expect(await otra.select(otra.abonosPrestamo).get().then((l) => l.length), 1);
    expect(await otra.select(otra.pagosEmpleado).get().then((l) => l.length), 1);
    expect(await otra.watchSaldoCentavos().first, await db.watchSaldoCentavos().first);
  });

  test('rechaza un archivo que no es una copia y no toca los datos', () async {
    await llenar(db);
    final falso = File('${carpeta.path}/falso.cuadra')
      ..writeAsStringSync('esto no es una base de datos');

    await expectLater(db.restaurarRespaldo(falso), throwsA(isA<RespaldoInvalido>()));

    expect((await db.negocioActual())!.nombre, 'Tienda Ronny');
    expect(await db.select(db.prestamos).get().then((l) => l.length), 1);
  });

  test('borrar todos los datos deja la app como nueva', () async {
    await llenar(db);
    await db.borrarTodosLosDatos();

    expect(await db.negocioActual(), isNull);
    expect(await db.select(db.movimientos).get(), isEmpty);
    expect(await db.select(db.prestamos).get(), isEmpty);
    expect(await db.select(db.empleados).get(), isEmpty);
    // Las categorías predeterminadas se conservan.
    expect(await db.select(db.categorias).get(), isNotEmpty);
  });
}
