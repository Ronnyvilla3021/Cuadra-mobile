import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money.dart';
import 'ajustes_prestamos.dart';

/// Ajustes de préstamos: de dónde sale el dinero y límite para prestar.
class AjustesPrestamosSheet extends ConsumerStatefulWidget {
  const AjustesPrestamosSheet({super.key});

  @override
  ConsumerState<AjustesPrestamosSheet> createState() =>
      _AjustesPrestamosSheetState();
}

class _AjustesPrestamosSheetState extends ConsumerState<AjustesPrestamosSheet> {
  final _formKey = GlobalKey<FormState>();
  late bool _salen;
  late final TextEditingController _limiteCtrl;

  @override
  void initState() {
    super.initState();
    final a = ref.read(ajustesPrestamosProvider);
    _salen = a.salenDeCaja;
    _limiteCtrl = TextEditingController(
      text: a.limiteCentavos == null ? '' : montoPlano(a.limiteCentavos!),
    );
  }

  @override
  void dispose() {
    _limiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final texto = _limiteCtrl.text.trim();
    await ref.read(ajustesPrestamosProvider.notifier).guardar(
          salenDeCaja: _salen,
          limiteCentavos: texto.isEmpty ? null : Money.parse(texto),
        );
    if (mounted) Navigator.of(context).pop();
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
                'Ajustes de préstamos',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Los préstamos salen de la caja'),
                subtitle: const Text(
                  'Es el valor inicial de cada préstamo nuevo; puedes cambiarlo '
                  'en cada uno. No modifica los préstamos ya creados.',
                ),
                value: _salen,
                onChanged: (v) => setState(() => _salen = v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _limiteCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Límite para prestar',
                  prefixText: r'$ ',
                  helperText:
                      'Máximo que puedes tener pendiente de cobro. '
                      'Déjalo vacío si no quieres límite.',
                  helperMaxLines: 3,
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null;
                  final c = Money.parse(t);
                  if (c == null || c == 0) return 'Monto no válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: _guardar, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
