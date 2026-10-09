import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/app_database.dart';
import '../../data/database/empleados_queries.dart';
import '../../data/providers.dart';
import 'empleado_form_sheet.dart';
import 'empleados_ui.dart';
import 'pago_empleado_sheet.dart';
import 'personal_providers.dart';

/// Ficha de un empleado: datos, resumen e historial de pagos.
class EmpleadoDetalleScreen extends ConsumerWidget {
  const EmpleadoDetalleScreen({super.key, required this.id});

  final int id;

  Future<void> _sheet(BuildContext context, Widget hoja) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => hoja,
    );
  }

  Future<void> _confirmar(
    BuildContext context, {
    required String titulo,
    required String texto,
    required String boton,
    required Future<void> Function() accion,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(boton),
          ),
        ],
      ),
    );
    if (ok == true) await accion();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumen = ref.watch(resumenEmpleadosProvider);
    final pagos = ref.watch(pagosEmpleadoProvider(id)).value ?? const <PagoEmpleado>[];
    final textTheme = Theme.of(context).textTheme;

    return resumen.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
      data: (lista) {
        final r = lista.where((x) => x.empleado.id == id).firstOrNull;
        if (r == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Este empleado ya no está.')),
          );
        }
        final e = r.empleado;
        final db = ref.read(appDatabaseProvider);

        return Scaffold(
          appBar: AppBar(
            title: Text(e.nombre),
            actions: [
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'editar') {
                    _sheet(context, EmpleadoFormSheet(empleado: e));
                  } else {
                    _confirmar(
                      context,
                      titulo: 'Quitar empleado',
                      texto: 'Dejará de aparecer en la lista. Sus pagos anteriores '
                          'se conservan en la caja y en los reportes.',
                      boton: 'Quitar',
                      accion: () async {
                        await db.desactivarEmpleado(e.id);
                        if (context.mounted) context.pop();
                      },
                    );
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'editar', child: Text('Editar')),
                  PopupMenuItem(value: 'quitar', child: Text('Quitar empleado')),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Money.format(e.tarifaCentavos)} ${e.tipoPago.tarifaPor}',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Cifra('Este mes', Money.format(r.pagadoMesCentavos)),
                          _Cifra('Total pagado', Money.format(r.pagadoTotalCentavos)),
                          _Cifra(
                            'Último pago',
                            r.ultimoPago == null ? '-' : fechaCorta(r.ultimoPago!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _sheet(context, PagoEmpleadoSheet(empleado: e)),
                icon: const Icon(Icons.payments_outlined),
                label: const Text('Registrar pago'),
              ),
              const SizedBox(height: 20),
              Text('Historial de pagos', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              if (pagos.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Todavía no hay pagos.', style: textTheme.bodySmall),
                ),
              for (final p in pagos)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.expense.withValues(alpha: 0.15),
                    child: const Icon(Icons.arrow_upward, color: AppColors.expense),
                  ),
                  title: Text(
                    '${textoUnidades(p.unidadesTrabajadas)} ${e.tipoPago.unidades}'
                    ' x ${Money.format(p.tarifaAplicadaCentavos)}',
                  ),
                  subtitle: Text(
                    [
                      fechaCorta(p.fecha),
                      if (p.bonificacionCentavos > 0)
                        'Bono ${Money.format(p.bonificacionCentavos)}',
                      if (p.deduccionCentavos > 0)
                        'Deducción ${Money.format(p.deduccionCentavos)}',
                      if ((p.nota ?? '').isNotEmpty) p.nota!,
                    ].join('  ·  '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Money.format(p.totalPagadoCentavos),
                        style: const TextStyle(
                          color: AppColors.expense,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Eliminar pago',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmar(
                          context,
                          titulo: 'Eliminar pago',
                          texto: 'Se borra este pago y también su gasto en la caja.',
                          boton: 'Eliminar',
                          accion: () => db.eliminarPagoEmpleado(p.id),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra(this.titulo, this.valor);

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(valor, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
