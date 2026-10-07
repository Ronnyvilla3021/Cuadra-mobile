import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/prestamos_queries.dart';
import '../pro/pro_gate.dart';
import 'ajustes_prestamos.dart';
import 'ajustes_prestamos_sheet.dart';
import 'estado_ui.dart';
import 'prestamos_providers.dart';

class PrestamosScreen extends StatelessWidget {
  const PrestamosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProGate(
      titulo: 'Préstamos',
      icono: Icons.request_quote,
      descripcion:
          'Registra a quién le prestas dinero, cuándo te pagan y cuánto te deben.',
      funciones: [
        (Icons.event, 'Calendario'),
        (Icons.history, 'Historial'),
        (Icons.notifications_none, 'Alertas'),
      ],
      child: _PrestamosLista(),
    );
  }
}

enum _Filtro { todos, conDeuda, pagados }

class _PrestamosLista extends ConsumerStatefulWidget {
  const _PrestamosLista();

  @override
  ConsumerState<_PrestamosLista> createState() => _PrestamosListaState();
}

class _PrestamosListaState extends ConsumerState<_PrestamosLista> {
  _Filtro _filtro = _Filtro.todos;

  int _orden(ResumenPrestamo a, ResumenPrestamo b) {
    final pagadoA = a.estado == EstadoPrestamo.pagado;
    final pagadoB = b.estado == EstadoPrestamo.pagado;
    if (pagadoA != pagadoB) return pagadoA ? 1 : -1;

    final va = a.prestamo.fechaVencimiento;
    final vb = b.prestamo.fechaVencimiento;
    if (va != null && vb != null) {
      final c = va.compareTo(vb);
      if (c != 0) return c;
    } else if (va != null) {
      return -1;
    } else if (vb != null) {
      return 1;
    }
    return b.prestamo.fechaPrestamo.compareTo(a.prestamo.fechaPrestamo);
  }

  @override
  Widget build(BuildContext context) {
    final datos = ref.watch(resumenPrestamosProvider);
    final ajustes = ref.watch(ajustesPrestamosProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Préstamos'),
        actions: [
          IconButton(
            tooltip: 'Calendario de cobros',
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => context.push('/prestamos/calendario'),
          ),
          IconButton(
            tooltip: 'Ajustes de préstamos',
            icon: const Icon(Icons.tune),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              useRootNavigator: true,
              showDragHandle: true,
              builder: (_) => const AjustesPrestamosSheet(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/prestamos/nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo préstamo'),
      ),
      body: datos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.request_quote_outlined, size: 56),
                    SizedBox(height: 12),
                    Text(
                      'Aún no hay préstamos.\nToca "Nuevo préstamo" para registrar el primero.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final ahora = DateTime.now();
          final pendiente = todos.fold<int>(0, (s, r) => s + r.pendienteCentavos);
          final vencidos = todos.where((r) => r.estaVencido(ahora)).length;
          final limite = ajustes.limiteCentavos;

          final visibles = todos.where((r) {
            switch (_filtro) {
              case _Filtro.todos:
                return true;
              case _Filtro.conDeuda:
                return r.estado != EstadoPrestamo.pagado;
              case _Filtro.pagados:
                return r.estado == EstadoPrestamo.pagado;
            }
          }).toList()
            ..sort(_orden);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Resumen(
                      titulo: 'Por cobrar',
                      valor: Money.format(pendiente),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Resumen(
                      titulo: 'Vencidos',
                      valor: '$vencidos',
                      color: vencidos > 0 ? AppColors.expense : AppColors.income,
                    ),
                  ),
                ],
              ),
              if (limite != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Límite para prestar: ${Money.format(limite)}  ·  '
                  'Disponible: ${Money.format(limite - pendiente)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: limite - pendiente < 0 ? AppColors.expense : null,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SegmentedButton<_Filtro>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: _Filtro.todos, label: Text('Todos')),
                  ButtonSegment(value: _Filtro.conDeuda, label: Text('Con deuda')),
                  ButtonSegment(value: _Filtro.pagados, label: Text('Pagados')),
                ],
                selected: {_filtro},
                onSelectionChanged: (s) => setState(() => _filtro = s.first),
              ),
              const SizedBox(height: 8),
              if (visibles.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No hay préstamos en este filtro.')),
                ),
              for (final r in visibles) _TarjetaPrestamo(resumen: r),
            ],
          );
        },
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({
    required this.titulo,
    required this.valor,
    required this.color,
  });

  final String titulo;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: textTheme.labelLarge?.copyWith(color: color)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valor,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaPrestamo extends StatelessWidget {
  const _TarjetaPrestamo({required this.resumen});

  final ResumenPrestamo resumen;

  @override
  Widget build(BuildContext context) {
    final r = resumen;
    final p = r.prestamo;
    final textTheme = Theme.of(context).textTheme;
    final color = r.estado.color;
    final ahora = DateTime.now();
    final vencido = r.estaVencido(ahora);
    final progreso = (r.pagadoCentavos / p.montoCentavos).clamp(0.0, 1.0);

    final String fecha;
    if (r.estado == EstadoPrestamo.pagado) {
      fecha = 'Préstamo del ${fechaCorta(p.fechaPrestamo)}';
    } else if (p.fechaVencimiento != null) {
      fecha =
          '${textoVencimiento(p.fechaVencimiento!, ahora)} (${fechaCorta(p.fechaVencimiento!)})';
    } else {
      fecha = 'Sin fecha de pago';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/prestamos/${p.id}'),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              r.cliente.nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          EstadoChip(estado: r.estado),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Prestado ${Money.format(p.montoCentavos)}  ·  '
                        'Pagado ${Money.format(r.pagadoCentavos)}',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        r.estado == EstadoPrestamo.pagado
                            ? 'Pagado completo'
                            : 'Pendiente ${Money.format(r.pendienteCentavos)}',
                        style: textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progreso,
                          minHeight: 6,
                          color: color,
                          backgroundColor: color.withValues(alpha: 0.15),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 16,
                            color: vencido ? AppColors.expense : null,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              fecha,
                              style: textTheme.bodySmall?.copyWith(
                                color: vencido ? AppColors.expense : null,
                                fontWeight: vencido ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
