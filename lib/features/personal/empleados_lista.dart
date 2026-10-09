import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import 'empleado_form_sheet.dart';
import 'empleados_ui.dart';
import 'personal_providers.dart';

/// Lista de empleados con lo pagado este mes.
class EmpleadosLista extends ConsumerWidget {
  const EmpleadosLista({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datos = ref.watch(resumenEmpleadosProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Empleados')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          useRootNavigator: true,
          showDragHandle: true,
          builder: (_) => const EmpleadoFormSheet(),
        ),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo empleado'),
      ),
      body: datos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge_outlined, size: 56),
                    SizedBox(height: 12),
                    Text(
                      'Aún no tienes empleados.\n'
                      'Toca "Nuevo empleado" para agregar al primero.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          final totalMes = lista.fold<int>(0, (a, r) => a + r.pagadoMesCentavos);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pagado este mes', style: textTheme.bodySmall),
                      const SizedBox(height: 2),
                      Text(
                        Money.format(totalMes),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${lista.length} ${lista.length == 1 ? 'empleado' : 'empleados'}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final r in lista)
                Card(
                  child: ListTile(
                    onTap: () => context.push('/personal/${r.empleado.id}'),
                    leading: CircleAvatar(
                      child: Text(r.empleado.nombre.trim()[0].toUpperCase()),
                    ),
                    title: Text(r.empleado.nombre),
                    subtitle: Text(
                      '${Money.format(r.empleado.tarifaCentavos)} '
                      '${r.empleado.tipoPago.tarifaPor}'
                      '${r.ultimoPago == null ? '' : '  ·  Último pago: ${fechaCorta(r.ultimoPago!)}'}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Money.format(r.pagadoMesCentavos),
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('este mes', style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
