import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/app_database.dart';
import '../../data/database/prestamos_queries.dart';
import '../../data/providers.dart';
import 'abono_sheet.dart';
import 'estado_ui.dart';
import 'prestamos_providers.dart';

/// Informe completo de un préstamo: estado, pagos, deuda y fechas.
class PrestamoDetalleScreen extends ConsumerWidget {
  const PrestamoDetalleScreen({super.key, required this.id});

  final int id;

  Future<void> _registrarPago(BuildContext context, ResumenPrestamo r) async {
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => AbonoSheet(
        prestamoId: r.prestamo.id,
        pendienteCentavos: r.pendienteCentavos,
      ),
    );
    if (guardado == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago registrado')),
      );
    }
  }

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    ResumenPrestamo r,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar préstamo'),
        content: const Text(
          'Se eliminarán el préstamo y todos sus pagos. Si salió de la caja, '
          'también se revierten sus movimientos y el saldo se recalcula.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(appDatabaseProvider).eliminarPrestamo(r.prestamo.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumen = ref.watch(resumenPrestamosProvider);
    final abonos = ref.watch(abonosProvider(id)).value ?? const <AbonoPrestamo>[];

    return resumen.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (lista) {
        final r = lista.where((x) => x.prestamo.id == id).firstOrNull;
        if (r == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Este préstamo ya no existe.')),
          );
        }
        return _contenido(context, ref, r, abonos);
      },
    );
  }

  Widget _contenido(
    BuildContext context,
    WidgetRef ref,
    ResumenPrestamo r,
    List<AbonoPrestamo> abonos,
  ) {
    final p = r.prestamo;
    final textTheme = Theme.of(context).textTheme;
    final color = r.estado.color;
    final ahora = DateTime.now();
    final vencido = r.estaVencido(ahora);
    final progreso = (r.pagadoCentavos / p.montoCentavos).clamp(0.0, 1.0);

    final String pago;
    if (r.estado == EstadoPrestamo.pagado) {
      pago = 'Pagado por completo';
    } else if (p.fechaVencimiento != null) {
      pago =
          '${fechaCorta(p.fechaVencimiento!)}  ·  ${textoVencimiento(p.fechaVencimiento!, ahora)}';
    } else {
      pago = 'Sin fecha de pago';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(r.cliente.nombre),
        actions: [
          PopupMenuButton<String>(
            onSelected: (_) => _eliminar(context, ref, r),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'eliminar', child: Text('Eliminar préstamo')),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          r.cliente.nombre,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      EstadoChip(estado: r.estado),
                    ],
                  ),
                  if ((r.cliente.telefono ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(r.cliente.telefono!, style: textTheme.bodyMedium),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Cifra('Prestado', Money.format(p.montoCentavos), null),
                      _Cifra('Pagado', Money.format(r.pagadoCentavos), AppColors.income),
                      _Cifra('Pendiente', Money.format(r.pendienteCentavos), color),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progreso,
                      minHeight: 8,
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _Fila(Icons.event_note_outlined, 'Fecha del préstamo', fechaCorta(p.fechaPrestamo)),
                _Fila(
                  Icons.event,
                  'Fecha de pago',
                  pago,
                  color: vencido ? AppColors.expense : null,
                ),
                _Fila(
                  Icons.account_balance_wallet_outlined,
                  'Salió de la caja',
                  p.salioDeCaja ? 'Sí' : 'No',
                ),
                if ((p.nota ?? '').isNotEmpty) _Fila(Icons.notes, 'Nota', p.nota!),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (r.pendienteCentavos > 0)
            FilledButton.icon(
              onPressed: () => _registrarPago(context, r),
              icon: const Icon(Icons.payments_outlined),
              label: const Text('Registrar pago'),
            ),
          const SizedBox(height: 20),
          Text('Historial', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          for (final a in abonos)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.income.withValues(alpha: 0.15),
                child: const Icon(Icons.arrow_downward, color: AppColors.income),
              ),
              title: const Text('Pago recibido'),
              subtitle: Text(
                [
                  fechaCorta(a.fecha),
                  if ((a.nota ?? '').isNotEmpty) a.nota!,
                ].join('  ·  '),
              ),
              trailing: Text(
                '+${Money.format(a.montoCentavos)}',
                style: const TextStyle(
                  color: AppColors.income,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.expense.withValues(alpha: 0.15),
              child: const Icon(Icons.arrow_upward, color: AppColors.expense),
            ),
            title: const Text('Préstamo entregado'),
            subtitle: Text(fechaCorta(p.fechaPrestamo)),
            trailing: Text(
              Money.format(p.montoCentavos),
              style: const TextStyle(
                color: AppColors.expense,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (abonos.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Todavía no hay pagos.', style: textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra(this.titulo, this.valor, this.color);

  final String titulo;
  final String valor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          valor,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila(this.icono, this.titulo, this.valor, {this.color});

  final IconData icono;
  final String titulo;
  final String valor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icono, color: color),
      title: Text(titulo),
      subtitle: Text(
        valor,
        style: TextStyle(color: color, fontWeight: color == null ? null : FontWeight.bold),
      ),
    );
  }
}
