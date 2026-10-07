import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/core/utils/fechas.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/prestamos_queries.dart';
import 'package:mi_negocio/features/prestamos/calendario_prestamos_screen.dart';
import 'package:mi_negocio/features/prestamos/prestamos_providers.dart';

ResumenPrestamo _resumen({
  required int id,
  required String nombre,
  required DateTime vence,
  int monto = 10000,
  int pagado = 0,
}) {
  return ResumenPrestamo(
    prestamo: Prestamo(
      id: id,
      clienteId: id,
      montoCentavos: monto,
      fechaPrestamo: DateTime(2026, 1, 1),
      fechaVencimiento: vence,
      nota: null,
      salioDeCaja: false,
      movimientoId: null,
      creadoEn: DateTime(2026, 1, 1),
    ),
    cliente: Cliente(
      id: id,
      nombre: nombre,
      telefono: null,
      activo: true,
      creadoEn: DateTime(2026, 1, 1),
    ),
    pagadoCentavos: pagado,
  );
}

void main() {
  test('la cuadrícula tiene 6 semanas y empieza en lunes', () {
    // 1 de octubre de 2026 es jueves -> la cuadrícula empieza el lunes 28/09.
    final dias = diasDeCuadricula(DateTime(2026, 10));
    expect(dias.length, 42);
    expect(dias.first, DateTime(2026, 9, 28));
    expect(dias.first.weekday, DateTime.monday);
    expect(dias.last, DateTime(2026, 11, 8));
  });

  testWidgets('muestra los cobros del día seleccionado (hoy)', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final hoy = soloDia(DateTime.now());
    final manana = DateTime(hoy.year, hoy.month, hoy.day + 1);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          resumenPrestamosProvider.overrideWith(
            (ref) => Stream.value([
              _resumen(id: 1, nombre: 'Pablo', vence: hoy),
              _resumen(id: 2, nombre: 'Lucía', vence: manana),
            ]),
          ),
        ],
        child: const MaterialApp(home: CalendarioPrestamosScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Calendario de cobros'), findsOneWidget);
    expect(find.text('Pablo'), findsOneWidget); // vence hoy
    expect(find.text('Lucía'), findsNothing); // vence otro día
    expect(find.text('Con deuda'), findsWidgets);
  });
}
