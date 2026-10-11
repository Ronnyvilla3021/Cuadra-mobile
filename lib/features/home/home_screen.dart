import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/imagenes_app.dart';
import '../../data/database/app_database.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';
import '../caja/caja_providers.dart';
import 'home_providers.dart';

const _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _ocultarSaldo = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final negocio = ref.watch(negocioProvider).value;
    final saldo = ref.watch(saldoCentavosProvider);
    final resumen = ref.watch(resumenDiaProvider).value;
    final ultimos = ref.watch(ultimosMovimientosProvider);
    final nombresCategoria = {
      for (final c in ref.watch(categoriasProvider).value ?? const <Categoria>[])
        c.id: c.nombre,
    };
    final hoy = DateTime.now();

    String monto(int? centavos) =>
        centavos == null ? '--' : Money.format(centavos);

    final ganancia = resumen?.gananciaCentavos;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              negocio?.nombre ?? 'Cuadra',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Hoy, ${hoy.day} de ${_meses[hoy.month - 1]}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LetrasCuadra(alto: 28),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Dinero en caja
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF4F8DF7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dinero en caja',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      saldo.when(
                        data: (centavos) => Text(
                          _ocultarSaldo ? r'$ ••••••' : Money.format(centavos),
                          style: textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        loading: () => const SizedBox(
                          height: 36,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        error: (e, _) => const Text(
                          '--',
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: _ocultarSaldo ? 'Mostrar saldo' : 'Ocultar saldo',
                  color: Colors.white70,
                  icon: Icon(
                    _ocultarSaldo ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _ocultarSaldo = !_ocultarSaldo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Ventas y gastos de hoy
          Row(
            children: [
              Expanded(
                child: _TarjetaMonto(
                  icono: Icons.trending_up,
                  etiqueta: 'Ventas',
                  valor: monto(resumen?.ingresosCentavos),
                  color: AppColors.income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TarjetaMonto(
                  icono: Icons.trending_down,
                  etiqueta: 'Gastos',
                  valor: monto(resumen?.gastosCentavos),
                  color: AppColors.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ganancia estimada
          _TarjetaMonto(
            icono: Icons.savings_outlined,
            etiqueta: 'Ganancia estimada de hoy',
            valor: monto(ganancia),
            color: (ganancia ?? 0) < 0 ? AppColors.expense : Theme.of(context).colorScheme.primary,
            nota: 'Ventas − Gastos',
          ),
          const SizedBox(height: 20),

          // Últimos movimientos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Últimos movimientos', style: textTheme.titleMedium),
              TextButton(
                onPressed: () => context.go('/caja'),
                child: const Text('Ver todos'),
              ),
            ],
          ),
          ultimos.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (items) {
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Aún no hay movimientos.\nRegístralos en la pestaña Caja.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (final m in items)
                    _UltimoMovimiento(
                      movimiento: m,
                      categoria: nombresCategoria[m.categoriaId],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TarjetaMonto extends StatelessWidget {
  const _TarjetaMonto({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.color,
    this.nota,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;
  final String? nota;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Opaco: el color suave se mezcla con el de las tarjetas.
        color: Color.alphaBlend(
          color.withValues(alpha: 0.12),
          Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 18, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  etiqueta,
                  style: textTheme.labelLarge?.copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valor,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (nota != null) ...[
            const SizedBox(height: 2),
            Text(nota!, style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _UltimoMovimiento extends StatelessWidget {
  const _UltimoMovimiento({required this.movimiento, required this.categoria});

  final Movimiento movimiento;
  final String? categoria;

  @override
  Widget build(BuildContext context) {
    final esIngreso = movimiento.tipo == TipoMovimiento.ingreso;
    final color = esIngreso ? AppColors.income : AppColors.expense;
    final f = movimiento.fecha;
    final ahora = DateTime.now();
    final hora =
        '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';
    final esHoy =
        f.year == ahora.year && f.month == ahora.month && f.day == ahora.day;
    final cuando = esHoy
        ? 'Hoy $hora'
        : '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')} $hora';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
      subtitle: Text([?categoria, cuando].join('  ·  ')),
      trailing: Text(
        '${esIngreso ? '+' : '-'}${Money.format(movimiento.montoCentavos)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      ),
    );
  }
}
