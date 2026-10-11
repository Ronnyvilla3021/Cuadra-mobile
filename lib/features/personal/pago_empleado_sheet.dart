import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money.dart';
import '../../core/utils/pantalla.dart';
import '../../data/database/app_database.dart';
import '../../data/database/empleados_queries.dart';
import '../../data/providers.dart';
import 'empleados_ui.dart';

/// Registrar un pago a un empleado. Devuelve true si se guardó.
class PagoEmpleadoSheet extends ConsumerStatefulWidget {
  const PagoEmpleadoSheet({super.key, required this.empleado});

  final Empleado empleado;

  @override
  ConsumerState<PagoEmpleadoSheet> createState() => _PagoEmpleadoSheetState();
}

class _PagoEmpleadoSheetState extends ConsumerState<PagoEmpleadoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _unidadesCtrl = TextEditingController();
  final _bonoCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _unidadesCtrl.dispose();
    _bonoCtrl.dispose();
    _descCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  double? get _unidades =>
      double.tryParse(_unidadesCtrl.text.trim().replaceAll(',', '.'));
  int get _bono => Money.parse(_bonoCtrl.text) ?? 0;
  int get _desc => Money.parse(_descCtrl.text) ?? 0;

  int get _total => calcularTotalPago(
        tarifaCentavos: widget.empleado.tarifaCentavos,
        unidades: _unidades ?? 0,
        bonificacionCentavos: _bono,
        deduccionCentavos: _desc,
      );

  Future<void> _guardar() async {
    if (_guardando || !_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await ref.read(appDatabaseProvider).registrarPagoEmpleado(
            empleadoId: widget.empleado.id,
            unidades: _unidades!,
            bonificacionCentavos: _bono,
            deduccionCentavos: _desc,
            nota: _notaCtrl.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el pago.')),
      );
    }
  }

  String? _validarOpcional(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    return Money.parse(t) == null ? 'Monto no válido' : null;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.empleado;
    final textTheme = Theme.of(context).textTheme;
    final filtro = FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        espacioInferiorHoja(context),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pago a ${e.nombre}',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text('${Money.format(e.tarifaCentavos)} ${e.tipoPago.tarifaPor}'),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('campo_unidades_pago'),
                controller: _unidadesCtrl,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [filtro],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Cuántas ${e.tipoPago.unidades} trabajó',
                ),
                validator: (v) {
                  final t = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (t == null) return 'Escribe un número (ejemplo: 8 o 7.5)';
                  if (t <= 0) return 'Debe ser mayor que cero';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bonoCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [filtro],
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Bonificación',
                        prefixText: r'$ ',
                      ),
                      validator: _validarOpcional,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _descCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [filtro],
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Deducción',
                        prefixText: r'$ ',
                      ),
                      validator: _validarOpcional,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notaCtrl,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total a pagar'),
                    Text(
                      Money.format(_total < 0 ? 0 : _total),
                      key: const Key('total_pago'),
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sale de la caja como gasto.',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: (_guardando || _total <= 0) ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
