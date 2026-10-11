import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/core/theme/app_theme.dart';

void main() {
  for (final entry in {'claro': AppTheme.light, 'oscuro': AppTheme.dark}.entries) {
    testWidgets('el tema ${entry.key} dibuja los componentes principales',
        (t) async {
      await t.pumpWidget(
        MaterialApp(
          theme: entry.value,
          home: Scaffold(
            body: ListView(
              children: [
                const Card(child: ListTile(title: Text('Tarjeta'))),
                const TextField(decoration: InputDecoration(labelText: 'Campo')),
                FilledButton(onPressed: () {}, child: const Text('Botón')),
                const ChoiceChip(label: Text('Chip'), selected: true),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('Uno')),
                    ButtonSegment(value: 2, label: Text('Dos')),
                  ],
                  selected: const {1},
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'A'),
                NavigationDestination(icon: Icon(Icons.abc), label: 'B'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Tarjeta'), findsOneWidget);
      expect(tester(t), isNull);
    });
  }
}

Object? tester(WidgetTester t) => t.takeException();
