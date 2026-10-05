import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/app.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/providers.dart';

void main() {
  testWidgets('con negocio configurado, el splash lleva al Inicio',
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
          saldoCentavosProvider.overrideWith((ref) => Stream.value(0)),
        ],
        child: const CuadraApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tienda de prueba'), findsOneWidget);
    expect(find.text('Caja'), findsWidgets);
    expect(find.text(r'$0.00'), findsOneWidget);
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
