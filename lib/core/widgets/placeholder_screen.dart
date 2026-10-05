import 'package:flutter/material.dart';

/// Pantalla temporal "en construcción" para las secciones aún no desarrolladas.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 16),
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Pantalla en construcción', style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
