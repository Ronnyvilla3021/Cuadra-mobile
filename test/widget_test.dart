import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/app.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/dashboard_queries.dart';
import 'package:mi_negocio/data/providers.dart';
import 'package:mi_negocio/features/caja/caja_providers.dart';
import 'package:mi_negocio/features/home/home_providers.dart';

void main() {
  testWidgets('con negocio configurado, el splash lleva al Dashboard',
      (tester) async {
    final negocio = Negocio(
      id: 1,
      nombre: 'Tienda de prueba',
      tipoNegocio: 'Tienda',
      moneda: 'USD',
      saldoInicialCentavos: 0,
      creadoEn: DateTime(2026, 10, 5),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Evitan abrir la base de datos real en la prueba.
          negocioProvider.overrideWith((ref) => Stream<Negocio?>.value(negocio)),
          negocioInicialProvider.overrideWith((ref) async => negocio),
          saldoCentavosProvider.overrideWith((ref) => Stream.value(38550)),
          resumenDiaProvider.overrideWith(
            (ref) => Stream.value(
              const ResumenDia(ingresosCentavos: 52000, gastosCentavos: 13450),
            ),
          ),
          ultimosMovimientosProvider.overrideWith(
            (ref) => Stream.value(<Movimiento>[]),
          ),
          categoriasProvider.overrideWith(
            (ref) => Stream.value(<Categoria>[]),
          ),
        ],
        child: const CuadraApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tienda de prueba'), findsOneWidget);
    expect(find.text('Dinero en caja'), findsOneWidget);
    expect(find.text(r'$520.00'), findsOneWidget); // ventas
    expect(find.text(r'$134.50'), findsOneWidget); // gastos
    // $385.50 aparece dos veces: dinero en caja y ganancia (520 - 134.50).
    expect(find.text(r'$385.50'), findsNWidgets(2));
  });

  testWidgets('sin negocio, el splash lleva a la bienvenida', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          negocioProvider.overrideWith((ref) => Stream<Negocio?>.value(null)),
          negocioInicialProvider.overrideWith((ref) async => null),
        ],
        child: const CuadraApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('¡Bienvenido!'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
