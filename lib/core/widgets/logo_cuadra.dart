import 'package:flutter/material.dart';

/// Logo de Cuadra (assets/images/logo.png). Si la imagen no está declarada en
/// pubspec.yaml o no existe, muestra un ícono en su lugar y la app no se rompe.
class LogoCuadra extends StatelessWidget {
  const LogoCuadra({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      errorBuilder: (context, error, stack) => Icon(
        Icons.storefront_rounded,
        size: size * 0.8,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
