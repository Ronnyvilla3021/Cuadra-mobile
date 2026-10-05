import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../data/database/app_database.dart';
import '../../data/database/caja_queries.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';
import 'caja_providers.dart';
import 'movimiento_sheet.dart';

class CajaScreen extends ConsumerStatefulWidget {
  const CajaScreen({super.key});

  @override
  ConsumerState<CajaScreen> createState() => _CajaScreenState();
}

class _CajaScreenState extends ConsumerState<CajaScreen> {
  static const _pagina = 30;

  TipoMovimiento? _filtro;
  int _limite = _pagina;

  Future<void> _registrar(TipoMovimiento tipo) async {
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => MovimientoSheet(tipo: tipo),
    );
    if (guardado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tipo == TipoMovimiento.ingreso
                ? 'Ingreso registrado'
                : 'Gasto registrado',
          ),
        ),
      );
    }
  }

  Future<void> _confirmarEliminar(Movimiento m) async {
    if (m.origen != OrigenMovimiento.manual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Este movimiento viene de un pago y no se puede eliminar desde aquí.',
          ),
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar movimiento'),
        content: Text(
          '${m.concepto}  ·  ${Money.format(m.montoCentavos)}\n\n'
          'El saldo de la caja se recalculará.',
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
    if (ok == true) {
      await ref.read(appDatabaseProvider).eliminarMovimientoManual(m.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final movimientos = ref.watch(
      movimientosCajaProvider((tipo: _filtro, limite: _limite)),
    );
    final saldo = ref.watch(saldoCentavosProvider);
    final nombresCategoria = {
      for (final c in ref.watch(categoriasProvider).value ?? const <Categoria>[])
        c.id: c.nombre,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Caja')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<TipoMovimiento?>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<TipoMovimiento?>>[
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(
                      value: TipoMovimiento.ingreso,
                      label: Text('Ingresos'),
                    ),
                    ButtonSegment(
                      value: TipoMovimiento.gasto,
                      label: Text('Gastos'),
                    ),
                  ],
                  selected: {_filtro},
                  onSelectionChanged: (s) => setState(() {
                    _filtro = s.first;
                    _limite = _pagina;
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.income,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _registrar(TipoMovimiento.ingreso),
                        icon: const Icon(Icons.add),
                        label: const Text('Ingreso'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.expense,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _registrar(TipoMovimiento.gasto),
                        icon: const Icon(Icons.remove),
                        label: const Text('Gasto'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historial de movimientos',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mantén presionado un movimiento para eliminarlo',
                style: textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: movimientos.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (items) {
                if (items.isEmpty) {
                  return const _EstadoVacio();
                }
                final hayMas = items.length >= _limite;
                return ListView.builder(
                  itemCount: items.length + (hayMas ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == items.length) {
                      return TextButton(
                        onPressed: () => setState(() => _limite += _pagina),
                        child: const Text('Ver más'),
                      );
                    }
                    final m = items[i];
                    return _MovimientoTile(
                      movimiento: m,
                      categoria: nombresCategoria[m.categoriaId],
                      onLongPress: () => _confirmarEliminar(m),
                    );
                  },
                );
              },
            ),
          ),
          _BarraSaldo(saldo: saldo),
        ],
      ),
    );
  }
}

class _MovimientoTile extends StatelessWidget {
  const _MovimientoTile({
    required this.movimiento,
    required this.categoria,
    required this.onLongPress,
  });

  final Movimiento movimiento;
  final String? categoria;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final esIngreso = movimiento.tipo == TipoMovimiento.ingreso;
    final color = esIngreso ? AppColors.income : AppColors.expense;
    final subtitulo = [
      if (categoria != null) categoria!,
      _formatearFecha(movimiento.fecha),
    ].join('  ·  ');

    return ListTile(
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          esIngreso ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
        ),
      ),
      title: Text(
        movimiento.concepto,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(subtitulo),
      trailing: Text(
        '${esIngreso ? '+' : '-'}${Money.format(movimiento.montoCentavos)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _BarraSaldo extends StatelessWidget {
  const _BarraSaldo({required this.saldo});

  final AsyncValue<int> saldo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: scheme.primary.withValues(alpha: 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Saldo actual', style: textTheme.titleMedium),
          saldo.when(
            data: (centavos) => Text(
              Money.format(centavos),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: centavos < 0 ? AppColors.expense : null,
              ),
            ),
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (e, _) => const Text('--'),
          ),
        ],
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 56),
            SizedBox(height: 12),
            Text(
              'Aún no hay movimientos.\nRegistra tu primer ingreso o gasto.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatearFecha(DateTime f) {
  final ahora = DateTime.now();
  final hora =
      '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';
  final esHoy =
      f.year == ahora.year && f.month == ahora.month && f.day == ahora.day;
  if (esHoy) return 'Hoy $hora';
  return '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')} $hora';
}
