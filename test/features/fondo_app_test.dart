import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/core/widgets/imagenes_app.dart';

void main() {
  testWidgets('FondoApp se muestra aunque falten las imágenes', (t) async {
    for (final modo in [ThemeMode.light, ThemeMode.dark]) {
      await t.pumpWidget(
        MaterialApp(
          themeMode: modo,
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          builder: (context, child) => FondoApp(child: child!),
          home: const Scaffold(body: Text('hola')),
        ),
      );
      expect(find.text('hola'), findsOneWidget);
    }
  });
}
