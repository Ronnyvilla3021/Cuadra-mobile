import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/prestamos_queries.dart';
import 'estado_ui.dart';
import 'prestamos_providers.dart';

const _meses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

const _diasSemana = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

/// Los 42 días (6 semanas, empezando en lunes) que llenan la cuadrícula del mes.
List<DateTime> diasDeCuadricula(DateTime mes) {
  final primero = DateTime(mes.year, mes.month, 1);
  final desfase = primero.weekday - 1; // lunes = 0
  return [
    for (var i = 0; i < 42; i++)
      DateTime(primero.year, primero.month, 1 - desfase + i),
  ];
}

/// Calendario simple con las fechas en que te deben pagar.
/// Cada día muestra puntos de color: rojo = con deuda, morado = pago parcial,
/// verde = pagado.
class CalendarioPrestamosScreen extends ConsumerStatefulWidget {
  const CalendarioPrestamosScreen({super.key});

  @override
  ConsumerState<CalendarioPrestamosScreen> createState() =>
      _CalendarioPrestamosScreenState();
}

class _CalendarioPrestamosScreenState
    extends ConsumerState<CalendarioPrestamosScreen> {
  late DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);
  late DateTime _seleccionado = soloDia(DateTime.now());

  void _cambiarMes(int delta) {
    setState(() => _mes = DateTime(_mes.year, _mes.month + delta));
  }

  void _irAHoy() {
    final hoy = DateTime.now();
    setState(() {
      _mes = DateTime(hoy.year, hoy.month);
      _seleccionado = soloDia(hoy);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final todos =
        ref.watch(resumenPrestamosProvider).value ?? const <ResumenPrestamo>[];

    // Préstamos agrupados por su fecha de pago.
    final porDia = <DateTime, List<ResumenPrestamo>>{};
    for (final r in todos) {
      final v = r.prestamo.fechaVencimiento;
      if (v == null) continue;
      porDia.putIfAbsent(soloDia(v), () => []).add(r);
    }

    final hoy = soloDia(DateTime.now());
    final dias = diasDeCuadricula(_mes);

    // Resumen del mes que se está viendo.
    final delMes = todos.where((r) {
      final v = r.prestamo.fechaVencimiento;
      return v != null &&
          v.year == _mes.year &&
          v.month == _mes.month &&
          r.estado != EstadoPrestamo.pagado;
    }).toList();
    final porCobrarMes = delMes.fold<int>(0, (s, r) => s + r.pendienteCentavos);

    final delDia = [...(porDia[_seleccionado] ?? const <ResumenPrestamo>[])]
      ..sort((a, b) => a.estado.index.compareTo(b.estado.index));
    final etiquetaDia =
        _seleccionado == hoy ? 'Hoy, ${fechaCorta(_seleccionado)}' : fechaCorta(_seleccionado);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de cobros'),
        actions: [TextButton(onPressed: _irAHoy, child: const Text('Hoy'))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Mes anterior',
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _cambiarMes(-1),
              ),
              Expanded(
                child: Text(
                  '${_meses[_mes.month - 1]} ${_mes.year}',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                tooltip: 'Mes siguiente',
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _cambiarMes(1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final d in _diasSemana)
                Expanded(
                  child: Center(child: Text(d, style: textTheme.labelMedium)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.95,
            children: [
              for (final dia in dias)
                _CeldaDia(
                  dia: dia,
                  delMes: dia.month == _mes.month,
                  esHoy: dia == hoy,
                  seleccionado: dia == _seleccionado,
                  estados: (porDia[dia] ?? const <ResumenPrestamo>[])
                      .map((r) => r.estado)
                      .toSet()
                      .toList()
                    ..sort((a, b) => a.index.compareTo(b.index)),
                  onTap: () => setState(() => _seleccionado = dia),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              for (final e in EstadoPrestamo.values) _Leyenda(estado: e),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            delMes.isEmpty
                ? 'Este mes no hay cobros pendientes.'
                : 'Este mes: ${delMes.length} '
                    '${delMes.length == 1 ? 'cobro' : 'cobros'} · '
                    '${Money.format(porCobrarMes)} por cobrar',
            style: textTheme.bodyMedium,
          ),
          const Divider(height: 32),
          Text(etiquetaDia, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          if (delDia.isEmpty)
            Text('No hay cobros para este día.', style: textTheme.bodyMedium),
          for (final r in delDia)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: r.estado.color.withValues(alpha: 0.15),
                  child: Icon(Icons.person_outline, color: r.estado.color),
                ),
                title: Text(r.cliente.nombre),
                subtitle: Text(
                  r.estado == EstadoPrestamo.pagado
                      ? 'Pagado completo'
                      : 'Pendiente ${Money.format(r.pendienteCentavos)}',
                  style: TextStyle(color: r.estado.color),
                ),
                trailing: EstadoChip(estado: r.estado),
                onTap: () => context.push('/prestamos/${r.prestamo.id}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _CeldaDia extends StatelessWidget {
  const _CeldaDia({
    required this.dia,
    required this.delMes,
    required this.esHoy,
    required this.seleccionado,
    required this.estados,
    required this.onTap,
  });

  final DateTime dia;
  final bool delMes;
  final bool esHoy;
  final bool seleccionado;
  final List<EstadoPrestamo> estados;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fuerte = seleccionado || esHoy;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: seleccionado ? scheme.primary.withValues(alpha: 0.18) : null,
            borderRadius: BorderRadius.circular(10),
            border: esHoy ? Border.all(color: scheme.primary, width: 1.5) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${dia.day}',
                style: TextStyle(
                  fontWeight: fuerte ? FontWeight.bold : null,
                  color: delMes ? null : scheme.onSurface.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final e in estados)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: e.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  const _Leyenda({required this.estado});

  final EstadoPrestamo estado;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: estado.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(estado.etiqueta, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
