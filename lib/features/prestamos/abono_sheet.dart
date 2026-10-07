import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money.dart';
import '../../data/database/prestamos_queries.dart';
import '../../data/providers.dart';
import 'ajustes_prestamos.dart';

/// Formulario para registrar un pago de un préstamo. Devuelve true si se guardó.
class AbonoSheet extends ConsumerStatefulWidget {
  const AbonoSheet({
    super.key,
    required this.prestamoId,
    required this.pendienteCentavos,
  });

  final int prestamoId;
  final int pendienteCentavos;

  @override
  ConsumerState<AbonoSheet> createState() => _AbonoSheetState();
}

class _AbonoSheetState extends ConsumerState<AbonoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _montoCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_guardando || !_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      final nota = _notaCtrl.text.trim();
      await ref.read(appDatabaseProvider).registrarAbono(
            prestamoId: widget.prestamoId,
            montoCentavos: Money.parse(_montoCtrl.text)!,
            nota: nota.isEmpty ? null : nota,
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registrar pago',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Pendiente: ${Money.format(widget.pendienteCentavos)}'),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('campo_monto_abono'),
                controller: _montoCtrl,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Monto del pago',
                  prefixText: r'$ ',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Escribe el monto';
                  final c = Money.parse(t);
                  if (c == null) return 'Monto no válido (ejemplo: 10 o 10.50)';
                  if (c == 0) return 'El monto debe ser mayor que cero';
                  if (c > widget.pendienteCentavos) {
                    return 'No puede superar lo pendiente '
                        '(${Money.format(widget.pendienteCentavos)})';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(
                    () => _montoCtrl.text = montoPlano(widget.pendienteCentavos),
                  ),
                  child: Text('Pagar todo (${Money.format(widget.pendienteCentavos)})'),
                ),
              ),
              TextFormField(
                controller: _notaCtrl,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  counterText: '',
                ),
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
                    : const Text('Guardar pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
