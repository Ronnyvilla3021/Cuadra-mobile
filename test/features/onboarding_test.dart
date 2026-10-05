import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/onboarding/onboarding_screen.dart';

Future<void> _abrir(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
  );
}

void main() {
  testWidgets('el nombre del negocio es obligatorio', (tester) async {
    await _abrir(tester);

    await tester.tap(find.text('Comenzar'));
    await tester.pump();

    expect(find.text('Escribe el nombre de tu negocio'), findsOneWidget);
  });

  testWidgets('rechaza un monto inicial inválido', (tester) async {
    await _abrir(tester);

    await tester.enterText(find.byKey(const Key('campo_nombre')), 'Mi Tienda');
    await tester.enterText(find.byKey(const Key('campo_caja')), '12.555');
    await tester.tap(find.text('Comenzar'));
    await tester.pump();

    expect(
      find.text('Monto no válido (ejemplo: 100 o 100.50)'),
      findsOneWidget,
    );
  });
}
