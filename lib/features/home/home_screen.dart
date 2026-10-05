import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';

/// TEMPORAL (Paso 2): muestra el saldo desde la base de datos y, solo en
/// modo debug, un botón para insertar un ingreso de prueba. En el Paso 4 se
/// reemplaza por el Dashboard real.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saldo = ref.watch(saldoCentavosProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dinero en caja', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            saldo.when(
              data: (centavos) => Text(
                Money.format(centavos),
                style: textTheme.displaySmall,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
            ),
          ],
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.bug_report),
              label: const Text('+\$1.00 (prueba)'),
              onPressed: () {
                ref.read(appDatabaseProvider).registrarMovimiento(
                      tipo: TipoMovimiento.ingreso,
                      concepto: 'Ingreso de prueba',
                      montoCentavos: 100,
                    );
              },
            )
          : null,
    );
  }
}
