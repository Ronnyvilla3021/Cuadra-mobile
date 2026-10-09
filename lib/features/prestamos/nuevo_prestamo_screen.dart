import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/app_database.dart';
import '../../data/database/prestamos_queries.dart';
import '../../data/providers.dart';
import '../ads/ad_config.dart';
import '../alertas/servicio_alertas.dart';
import 'ajustes_prestamos.dart';
import 'prestamos_providers.dart';

class NuevoPrestamoScreen extends ConsumerStatefulWidget {
  const NuevoPrestamoScreen({super.key});

  @override
  ConsumerState<NuevoPrestamoScreen> createState() =>
      _NuevoPrestamoScreenState();
}

class _NuevoPrestamoScreenState extends ConsumerState<NuevoPrestamoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();

  late DateTime _fecha = soloDia(DateTime.now());
  DateTime? _vencimiento;
  int? _plazoDias = 30;
  late bool _salioDeCaja;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _salioDeCaja = ref.read(ajustesPrestamosProvider).salenDeCaja;
    _vencimiento = _desdeFecha(30);
    _nombreCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telCtrl.dispose();
    _montoCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  DateTime _desdeFecha(int dias) =>
      DateTime(_fecha.year, _fecha.month, _fecha.day + dias);

  Future<void> _elegirFechaPrestamo() async {
    final f = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Fecha del préstamo',
    );
    if (f == null) return;
    setState(() {
      _fecha = soloDia(f);
      if (_plazoDias != null) {
        _vencimiento = _desdeFecha(_plazoDias!);
      } else if (_vencimiento != null && _vencimiento!.isBefore(_fecha)) {
        _vencimiento = _fecha;
      }
    });
  }

  Future<void> _elegirFechaPago() async {
    final f = await showDatePicker(
      context: context,
      initialDate: _vencimiento ?? _fecha,
      firstDate: _fecha,
      lastDate: DateTime(2100),
      helpText: 'Fecha de pago',
    );
    if (f == null) return;
    setState(() {
      _plazoDias = null;
      _vencimiento = soloDia(f);
    });
  }

  Future<bool> _confirmar(List<String> avisos) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revisa antes de prestar'),
        content: Text(avisos.join('\n\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Prestar de todos modos'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _guardar() async {
    if (_guardando || !_formKey.currentState!.validate()) return;

    final monto = Money.parse(_montoCtrl.text)!;
    final lista = ref.read(resumenPrestamosProvider).value ?? const [];
    final pendienteTotal = lista.fold<int>(0, (s, r) => s + r.pendienteCentavos);
    final limite = ref.read(ajustesPrestamosProvider).limiteCentavos;
    final saldo = _salioDeCaja ? ref.read(saldoCentavosProvider).value : null;

    final avisos = <String>[
      if (limite != null && pendienteTotal + monto > limite)
        'Superas tu límite para prestar (${Money.format(limite)}). '
            'Hoy tienes ${Money.format(pendienteTotal)} pendiente de cobro.',
      if (saldo != null && monto > saldo)
        'La caja tiene ${Money.format(saldo)} y el préstamo es de ${Money.format(monto)}.',
    ];
    if (avisos.isNotEmpty && !await _confirmar(avisos)) return;
    if (!mounted) return;

    setState(() => _guardando = true);
    try {
      final nota = _notaCtrl.text.trim();
      await ref.read(appDatabaseProvider).crearPrestamo(
            nombrePersona: _nombreCtrl.text,
            telefono: _telCtrl.text,
            montoCentavos: monto,
            fechaPrestamo: _fecha,
            fechaVencimiento: _vencimiento,
            nota: nota.isEmpty ? null : nota,
            salioDeCaja: _salioDeCaja,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo registrado')),
      );
      if (_vencimiento != null) await _ofrecerAvisos();
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el préstamo.')),
      );
    }
  }

  /// La primera vez que hay una fecha de pago, explica los avisos y pide el
  /// permiso de notificaciones de Android.
  Future<void> _ofrecerAvisos() async {
    final servicio = ref.read(servicioAlertasProvider);
    if (!AdConfig.disponible ||
        !ref.read(avisosCobroProvider) ||
        servicio.yaPreguntado()) {
      return;
    }
    final acepta = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Avisarte cuando te toque cobrar?'),
        content: const Text(
          'Cuadra puede mostrarte una notificación el día anterior y el día '
          'del cobro, a las 9:00. Funciona sin internet y puedes '
          'desactivarlo cuando quieras en Ajustes de préstamos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Ahora no'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Activar avisos'),
          ),
        ],
      ),
    );
    await servicio.marcarPreguntado();
    final notifier = ref.read(avisosCobroProvider.notifier);
    if (acepta == true) {
      if (!await servicio.pedirPermiso()) await notifier.establecer(false);
    } else {
      await notifier.establecer(false);
    }
  }

  List<Cliente> _sugerencias(List<ResumenPrestamo> lista) {
    final texto = _nombreCtrl.text.trim().toLowerCase();
    final vistos = <int>{};
    final salida = <Cliente>[];
    for (final r in lista) {
      if (!vistos.add(r.cliente.id)) continue;
      final nombre = r.cliente.nombre.toLowerCase();
      if (texto.isNotEmpty && !nombre.contains(texto)) continue;
      if (nombre == texto) continue;
      salida.add(r.cliente);
      if (salida.length == 6) break;
    }
    return salida;
  }

  @override
  Widget build(BuildContext context) {
    final lista = ref.watch(resumenPrestamosProvider).value ?? const <ResumenPrestamo>[];
    final ajustes = ref.watch(ajustesPrestamosProvider);
    final textTheme = Theme.of(context).textTheme;

    final pendienteTotal = lista.fold<int>(0, (s, r) => s + r.pendienteCentavos);
    final limite = ajustes.limiteCentavos;
    final sugerencias = _sugerencias(lista);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo préstamo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            TextFormField(
              key: const Key('campo_persona'),
              controller: _nombreCtrl,
              maxLength: 80,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '¿A quién le prestas?',
                hintText: 'Nombre de la persona',
                counterText: '',
              ),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 2 ? 'Escribe el nombre de la persona' : null,
            ),
            if (sugerencias.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in sugerencias)
                    ActionChip(
                      avatar: const Icon(Icons.person_outline, size: 18),
                      label: Text(c.nombre),
                      onPressed: () => setState(() {
                        _nombreCtrl.text = c.nombre;
                        _telCtrl.text = c.telefono ?? '';
                      }),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            _AvisoDeuda(nombre: _nombreCtrl.text.trim(), lista: lista),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
              decoration: const InputDecoration(
                labelText: 'Teléfono (opcional)',
                helperText: 'Sirve para recordarle el pago por WhatsApp',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('campo_monto_prestamo'),
              controller: _montoCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: '¿Cuánto le prestas?',
                prefixText: r'$ ',
                hintText: '0.00',
                helperText: limite == null
                    ? null
                    : 'Disponible para prestar: ${Money.format(limite - pendienteTotal)}',
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Escribe el monto';
                final c = Money.parse(t);
                if (c == null) return 'Monto no válido (ejemplo: 100 o 100.50)';
                if (c == 0) return 'El monto debe ser mayor que cero';
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_note_outlined),
              title: const Text('Fecha del préstamo'),
              subtitle: Text(fechaCorta(_fecha)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _elegirFechaPrestamo,
            ),
            const SizedBox(height: 4),
            Text('¿Para cuándo te paga?', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final d in const [7, 15, 30])
                  ChoiceChip(
                    label: Text('$d días'),
                    selected: _plazoDias == d,
                    onSelected: (_) => setState(() {
                      _plazoDias = d;
                      _vencimiento = _desdeFecha(d);
                    }),
                  ),
                ChoiceChip(
                  label: const Text('Elegir fecha'),
                  selected: _plazoDias == null && _vencimiento != null,
                  onSelected: (_) => _elegirFechaPago(),
                ),
                ChoiceChip(
                  label: const Text('Sin fecha'),
                  selected: _vencimiento == null,
                  onSelected: (_) => setState(() {
                    _plazoDias = null;
                    _vencimiento = null;
                  }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _vencimiento == null
                    ? 'Sin fecha de pago: no aparecerá en el calendario.'
                    : 'Pagará el ${fechaCorta(_vencimiento!)}',
                style: textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notaCtrl,
              maxLength: 120,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nota (opcional)',
                counterText: '',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sale de la caja'),
              subtitle: Text(
                _salioDeCaja
                    ? 'El saldo de la caja baja ahora y sube con cada cobro.'
                    : 'No afecta el saldo de la caja, ni al prestar ni al cobrar.',
              ),
              value: _salioDeCaja,
              onChanged: (v) => setState(() => _salioDeCaja = v),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar préstamo'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dice si la persona escrita ya tiene deudas.
class _AvisoDeuda extends StatelessWidget {
  const _AvisoDeuda({required this.nombre, required this.lista});

  final String nombre;
  final List<ResumenPrestamo> lista;

  @override
  Widget build(BuildContext context) {
    if (nombre.length < 2) return const SizedBox.shrink();

    final igual = lista
        .where((r) => r.cliente.nombre.trim().toLowerCase() == nombre.toLowerCase())
        .toList();
    final conDeuda = igual.where((r) => r.estado != EstadoPrestamo.pagado).toList();

    final Color color;
    final IconData icono;
    final String texto;

    if (conDeuda.isNotEmpty) {
      final deuda = conDeuda.fold<int>(0, (s, r) => s + r.pendienteCentavos);
      final vencidos = conDeuda.where((r) => r.estaVencido()).length;
      color = AppColors.expense;
      icono = Icons.warning_amber_rounded;
      texto = 'Ya debe ${Money.format(deuda)} en ${conDeuda.length} '
          '${conDeuda.length == 1 ? 'préstamo' : 'préstamos'}'
          '${vencidos > 0 ? ' ($vencidos vencido${vencidos == 1 ? '' : 's'})' : ''}.';
    } else if (igual.isNotEmpty) {
      color = AppColors.income;
      icono = Icons.check_circle_outline;
      texto = 'Sin deudas pendientes: ya te pagó todo lo anterior.';
    } else {
      color = Theme.of(context).colorScheme.primary;
      icono = Icons.person_add_alt_outlined;
      texto = 'Persona nueva: todavía no tiene préstamos.';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
