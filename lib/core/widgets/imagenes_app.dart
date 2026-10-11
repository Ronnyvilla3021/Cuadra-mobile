import 'package:flutter/material.dart';

/// Rutas de las imágenes de la app. Los archivos deben existir con estos
/// nombres exactos (sin espacios) y estar declarados en pubspec.yaml.
const kRutaLogo = 'assets/icon/logo.png';
const kRutaLetras = 'assets/icon/letras.png';
const kFondoOscuro = 'assets/images/fondo_oscuro.jpg';
const kFondoClaro = 'assets/images/fondo_claro.jpg';
const kFondoPro = 'assets/images/fondo_pro.jpg';

/// Oscurecido / aclarado que se pone encima del fondo para que los textos se
/// lean bien. Súbelo si el fondo distrae, bájalo (hasta 0) para verlo puro.
const kVeloFondoOscuro = 0.30;
const kVeloFondoClaro = 0.20;
const kVeloFondoPro = 0.45;

/// Logo de Cuadra. Si la imagen falta, muestra un ícono y la app no se rompe.
class LogoCuadra extends StatelessWidget {
  const LogoCuadra({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kRutaLogo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => Icon(
        Icons.storefront_rounded,
        size: size * 0.8,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Las letras "Cuadra" (assets/icon/letras.png). Si falta, muestra el texto.
class LetrasCuadra extends StatelessWidget {
  const LetrasCuadra({super.key, this.alto = 26});

  final double alto;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kRutaLetras,
      height: alto,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => Text(
        'Cuadra',
        style: TextStyle(fontSize: alto * 0.8, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Título de pantalla: las letras de Cuadra y, al lado, el nombre de la sección.
class TituloConLetras extends StatelessWidget {
  const TituloConLetras(this.seccion, {super.key});

  final String seccion;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LetrasCuadra(alto: 26),
        const SizedBox(width: 10),
        Container(width: 1, height: 20, color: color.withValues(alpha: 0.35)),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            seccion,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

/// Imagen de fondo a pantalla completa con un velo para que se lea el texto.
class FondoImagen extends StatelessWidget {
  const FondoImagen({
    super.key,
    required this.ruta,
    required this.colorVelo,
    required this.opacidadVelo,
    required this.colorRespaldo,
    this.child,
  });

  final String ruta;
  final Color colorVelo;
  final double opacidadVelo;

  /// Color liso que se ve si la imagen falta.
  final Color colorRespaldo;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          ruta,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          gaplessPlayback: true,
          errorBuilder: (context, error, stack) => ColoredBox(color: colorRespaldo),
        ),
        ColoredBox(color: colorVelo.withValues(alpha: opacidadVelo)),
        ?child,
      ],
    );
  }
}

/// Fondo de TODA la app: una imagen para el modo oscuro y otra para el claro.
/// Se pone en MaterialApp.builder; las pantallas tienen fondo transparente.
class FondoApp extends StatelessWidget {
  const FondoApp({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    return FondoImagen(
      ruta: oscuro ? kFondoOscuro : kFondoClaro,
      colorVelo: oscuro ? Colors.black : Colors.white,
      opacidadVelo: oscuro ? kVeloFondoOscuro : kVeloFondoClaro,
      colorRespaldo: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }
}
