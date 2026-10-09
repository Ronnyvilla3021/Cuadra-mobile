import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money.dart';
import '../../data/database/app_database.dart';
import '../../data/database/empleados_queries.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';
import '../prestamos/ajustes_prestamos.dart' show montoPlano;
import 'empleados_ui.dart';

/// Crear o editar un empleado. Devuelve true si se guardó.
class EmpleadoFormSheet extends ConsumerStatefulWidget {
  const EmpleadoFormSheet({super.key, this.empleado});

  final Empleado? empleado;

  @override
  ConsumerState<EmpleadoFormSheet> createState() => _EmpleadoFormSheetState();
}

class _EmpleadoFormSheetState extends ConsumerState<EmpleadoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl = TextEditingController(
    text: widget.empleado?.nombre ?? '',
  );
  late final TextEditingController _tarifaCtrl = TextEditingController(
    text: widget.empleado == null ? '' : montoPlano(widget.empleado!.tarifaCentavos),
  );
  late TipoPago _tipo = widget.empleado?.tipoPago ?? TipoPago.dia;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _tarifaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_guardando || !_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final tarifa = Money.parse(_tarifaCtrl.text)!;
      final e = widget.empleado;
      if (e == null) {
        await db.crearEmpleado(
          nombre: _nombreCtrl.text,
          tipoPago: _tipo,
          tarifaCentavos: tarifa,
        );
      } else {
        await db.actualizarEmpleado(
          e.id,
          nombre: _nombreCtrl.text,
          tipoPago: _tipo,
          tarifaCentavos: tarifa,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el empleado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final editando = widget.empleado != null;

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
                editando ? 'Editar empleado' : 'Nuevo empleado',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('campo_nombre_empleado'),
                controller: _nombreCtrl,
                autofocus: !editando,
                maxLength: 80,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  counterText: '',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Escribe el nombre' : null,
              ),
              const SizedBox(height: 12),
              Text('¿Cómo le pagas?', style: textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final t in TipoPago.values)
                    ChoiceChip(
                      label: Text(t.etiqueta),
                      selected: _tipo == t,
                      onSelected: (_) => setState(() => _tipo = t),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('campo_tarifa_empleado'),
                controller: _tarifaCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Tarifa ${_tipo.tarifaPor}',
                  prefixText: r'$ ',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Escribe la tarifa';
                  final c = Money.parse(t);
                  if (c == null) return 'Monto no válido (ejemplo: 10 o 10.50)';
                  if (c == 0) return 'La tarifa debe ser mayor que cero';
                  return null;
                },
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
                    : Text(editando ? 'Guardar cambios' : 'Agregar empleado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
