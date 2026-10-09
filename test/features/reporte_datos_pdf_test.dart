import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/empleados_queries.dart';
import 'package:mi_negocio/data/database/enums.dart';
import 'package:mi_negocio/data/database/prestamos_queries.dart';
import 'package:mi_negocio/features/reportes/reporte_datos.dart';
import 'package:mi_negocio/features/reportes/reporte_pdf.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> sembrar() async {
    final venta = await db.categoriaPredeterminadaId('Venta', TipoMovimiento.ingreso);
    final otros = await db.categoriaPredeterminadaId('Otros gastos', TipoMovimiento.gasto);
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta del día',
      montoCentavos: 10000,
      categoriaId: venta,
      fecha: DateTime(2026, 10, 5, 10),
    );
    await db.registrarMovimiento(
      tipo: TipoMovimiento.gasto,
      concepto: 'Bolsas',
      montoCentavos: 2500,
      categoriaId: otros,
      fecha: DateTime(2026, 10, 6, 9),
    );
    // Fuera del período:
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta vieja',
      montoCentavos: 999,
      fecha: DateTime(2026, 9, 1, 9),
    );
  }

  test('suma solo lo que cae dentro del período (último día incluido)', () async {
    await sembrar();
    await db.registrarMovimiento(
      tipo: TipoMovimiento.ingreso,
      concepto: 'Venta tarde',
      montoCentavos: 500,
      fecha: DateTime(2026, 10, 9, 23, 30),
    );

    final d = await db.cargarDatosReporte(
      desde: DateTime(2026, 10, 1),
      hasta: DateTime(2026, 10, 9),
    );

    expect(d.movimientos.length, 3);
    expect(d.ingresosCentavos, 10500);
    expect(d.gastosCentavos, 2500);
    expect(d.gananciaCentavos, 8000);
    expect(d.porCategoria(TipoMovimiento.gasto).first.key, 'Otros gastos');
  });

  test('incluye préstamos del período y el total por cobrar', () async {
    final id = await db.crearPrestamo(
      nombrePersona: 'Ana',
      montoCentavos: 5000,
      fechaPrestamo: DateTime(2026, 10, 3),
      salioDeCaja: false,
    );
    await db.registrarAbono(
      prestamoId: id,
      montoCentavos: 2000,
      fecha: DateTime(2026, 10, 4),
    );

    final d = await db.cargarDatosReporte(
      desde: DateTime(2026, 10, 1),
      hasta: DateTime(2026, 10, 9),
    );

    expect(d.prestamos.length, 1);
    expect(d.prestadoCentavos, 5000);
    expect(d.cobradoCentavos, 2000);
    expect(d.pendienteCentavos, 3000);
    expect(d.porCobrarTotalCentavos, 3000);
  });

  test('genera un PDF válido, con datos y también vacío', () async {
    await sembrar();
    final d = await db.cargarDatosReporte(
      desde: DateTime(2026, 10, 1),
      hasta: DateTime(2026, 10, 9),
    );
    final bytes = await construirReportePdf(
      datos: d,
      negocio: 'Tienda de Ronny 😀',
      incluirCaja: true,
      incluirPrestamos: true,
      incluirEmpleados: true,
      generado: DateTime(2026, 10, 9, 14, 30),
    );
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));

    final vacio = await db.cargarDatosReporte(
      desde: DateTime(2020, 1, 1),
      hasta: DateTime(2020, 1, 2),
    );
    final b2 = await construirReportePdf(
      datos: vacio,
      negocio: 'Tienda',
      incluirCaja: true,
      incluirPrestamos: true,
    );
    expect(ascii.decode(b2.sublist(0, 5)), '%PDF-');
  });

  test('incluye los pagos a empleados del período', () async {
    final id = await db.crearEmpleado(
      nombre: 'Luis',
      tipoPago: TipoPago.dia,
      tarifaCentavos: 2000,
    );
    await db.registrarPagoEmpleado(
      empleadoId: id,
      unidades: 5,
      bonificacionCentavos: 1000,
      deduccionCentavos: 500,
      fecha: DateTime(2026, 10, 7, 12),
    );
    await db.registrarPagoEmpleado(
      empleadoId: id,
      unidades: 1,
      fecha: DateTime(2026, 8, 7, 12), // fuera del período
    );

    final d = await db.cargarDatosReporte(
      desde: DateTime(2026, 10, 1),
      hasta: DateTime(2026, 10, 9),
    );

    expect(d.pagosEmpleados.length, 1);
    expect(d.pagosEmpleados.single.empleado, 'Luis');
    expect(d.empleadosTotalCentavos, 10500);
    expect(d.empleadosBonosCentavos, 1000);
    expect(d.empleadosDeduccionesCentavos, 500);

    final bytes = await construirReportePdf(
      datos: d,
      negocio: 'Tienda',
      incluirCaja: false,
      incluirPrestamos: false,
      incluirEmpleados: true,
    );
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
  });
}
