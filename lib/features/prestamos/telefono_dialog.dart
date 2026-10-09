import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'whatsapp.dart';

/// Pide el teléfono de la persona (para el recordatorio por WhatsApp).
/// Devuelve el texto escrito, o null si se cancela.
class TelefonoDialog extends StatefulWidget {
  const TelefonoDialog({super.key, required this.nombre, this.inicial = ''});

  final String nombre;
  final String inicial;

  @override
  State<TelefonoDialog> createState() => _TelefonoDialogState();
}

class _TelefonoDialogState extends State<TelefonoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ctrl = TextEditingController(
    text: widget.inicial,
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_ctrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Teléfono de ${widget.nombre}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _ctrl,
          autofocus: true,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
          decoration: const InputDecoration(
            labelText: 'Número de WhatsApp',
            hintText: '0991234567',
            helperText: 'Sin código de país se usa Ecuador (+593)',
          ),
          validator: (v) => telefonoParaWhatsapp(v ?? '') == null
              ? 'Escribe un número válido (ej. 0991234567)'
              : null,
          onFieldSubmitted: (_) => _guardar(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _guardar, child: const Text('Guardar y enviar')),
      ],
    );
  }
}
