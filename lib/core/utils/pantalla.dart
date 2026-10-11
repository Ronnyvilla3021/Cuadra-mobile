import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Espacio inferior para el contenido de una hoja: deja libre el teclado o,
/// si no hay teclado, la barra de navegación del sistema, más un margen.
double espacioInferiorHoja(BuildContext context, {double margen = 20}) {
  final media = MediaQuery.of(context);
  return margen + math.max(media.viewInsets.bottom, media.viewPadding.bottom);
}
