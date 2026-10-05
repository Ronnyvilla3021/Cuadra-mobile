import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/app.dart';

void main() {
  testWidgets('La app arranca y muestra la navegación', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CuadraApp()));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Caja'), findsWidgets);
  });
}
