import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/pro/pro_gate.dart';
import 'package:mi_negocio/features/pro/pro_providers.dart';

void main() {
  testWidgets('bloquea la función a usuarios gratis y la abre a PRO',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProGate(
            titulo: 'Fiados',
            icono: Icons.groups,
            descripcion: 'Controla quién te debe dinero.',
            funciones: [(Icons.history, 'Historial')],
            child: Text('contenido pro'),
          ),
        ),
      ),
    );

    // Usuario gratis: ve el candado y no el contenido.
    expect(find.text('Función disponible en Cuadra PRO'), findsOneWidget);
    expect(find.text('Desbloquear ahora'), findsOneWidget);
    expect(find.text('contenido pro'), findsNothing);

    // Pasa a PRO: se muestra el contenido.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProGate)),
    );
    container.read(isProProvider.notifier).establecer(true);
    await tester.pump();

    expect(find.text('contenido pro'), findsOneWidget);
    expect(find.text('Desbloquear ahora'), findsNothing);
  });
}
