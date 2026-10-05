import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/app.dart';
import 'package:mi_negocio/data/providers.dart';

void main() {
  testWidgets('La app arranca y muestra la navegación', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Evita abrir la base de datos real en la prueba.
          saldoCentavosProvider.overrideWith((ref) => Stream.value(0)),
        ],
        child: const CuadraApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Caja'), findsWidgets);
    expect(find.text(r'$0.00'), findsOneWidget);
  });
}
