import 'package:flutter/widgets.dart';

/// Tamaños de pantalla (basados en las guías de Material 3).
enum ScreenSize { compact, medium, expanded }

extension ScreenSizeX on BuildContext {
  /// compact  < 600 dp  -> celular
  /// medium   600-840   -> tablet vertical
  /// expanded > 840     -> tablet horizontal
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 600) return ScreenSize.compact;
    if (width < 840) return ScreenSize.medium;
    return ScreenSize.expanded;
  }
}
