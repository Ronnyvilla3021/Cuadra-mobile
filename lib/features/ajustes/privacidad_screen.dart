import 'package:flutter/material.dart';

import '../../core/app_info.dart';
import 'politica_texto.dart';

class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Política de privacidad')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text('Última actualización: $kFechaPolitica', style: textTheme.bodySmall),
          for (final (titulo, texto) in politicaPrivacidad) ...[
            const SizedBox(height: 20),
            Text(titulo, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(texto, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
