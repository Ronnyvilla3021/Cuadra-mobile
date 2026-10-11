import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/utils/pantalla.dart';
import '../../data/database/app_database.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';
import 'caja_providers.dart';

/// Formulario rápido para registrar un ingreso o un gasto.
/// Se cierra devolviendo `true` si se guardó.
class MovimientoSheet extends ConsumerStatefulWidget {
  const MovimientoSheet({super.key, required this.tipo});

  final TipoMovimiento tipo;

  @override
  ConsumerState<MovimientoSheet> createState() => _MovimientoSheetState();
}

class _MovimientoSheetState extends ConsumerState<MovimientoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _conceptoCtrl = TextEditingController();
  int? _categoriaId;
  bool _guardando = false;

  bool get _esIngreso => widget.tipo == TipoMovimiento.ingreso;
  Color get _color => _esIngreso ? AppColors.income : AppColors.expense;

  @override
  void dispose() {
    _montoCtrl.dispose();
    _conceptoCtrl.dispose();
    super.dispose();
  }

  Categoria? _seleccionada(List<Categoria> lista) {
    if (lista.isEmpty) return null;
    return lista.firstWhere(
      (c) => c.id == _categoriaId,
      orElse: () => lista.first,
    );
  }

  Future<void> _guardar(List<Categoria> categorias) async {
    if (_guardando || !_formKey.currentState!.validate()) return;

    final centavos = Money.parse(_montoCtrl.text)!;
    final categoria = _seleccionada(categorias);
    final texto = _conceptoCtrl.text.trim();
    final concepto = texto.isNotEmpty
        ? texto
        : (categoria?.nombre ?? (_esIngreso ? 'Ingreso' : 'Gasto'));

    setState(() => _guardando = true);
    try {
      await ref.read(appDatabaseProvider).registrarMovimiento(
            tipo: widget.tipo,
            concepto: concepto,
            montoCentavos: centavos,
            categoriaId: categoria?.id,
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final categorias = (ref.watch(categoriasProvider).value ?? const [])
        .where((c) => c.tipo == widget.tipo)
        .toList();
    final seleccionada = _seleccionada(categorias);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _esIngreso ? 'Registrar ingreso' : 'Registrar gasto',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _color,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('campo_monto'),
                controller: _montoCtrl,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                textInputAction: TextInputAction.next,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixText: r'$ ',
                  hintText: '0.00',
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Escribe el monto';
                  final centavos = Money.parse(v);
                  if (centavos == null) {
                    return 'Monto no válido (ejemplo: 12 o 12.50)';
                  }
                  if (centavos == 0) return 'El monto debe ser mayor que cero';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Categoría', style: textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in categorias)
                    ChoiceChip(
                      label: Text(c.nombre),
                      selected: seleccionada?.id == c.id,
                      onSelected: (_) => setState(() => _categoriaId = c.id),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('campo_concepto'),
                controller: _conceptoCtrl,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _guardar(categorias),
                decoration: InputDecoration(
                  labelText: 'Concepto (opcional)',
                  hintText: _esIngreso
                      ? 'Ej. Venta de productos'
                      : 'Ej. Compra de mercadería',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _color,
                  foregroundColor: Colors.white,
                ),
                onPressed: _guardando ? null : () => _guardar(categorias),
                child: _guardando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_esIngreso ? 'Guardar ingreso' : 'Guardar gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
