import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema de Cuadra. Todas las superficies (tarjetas, diálogos, hojas, campos,
/// chips, barra de navegación) salen de una misma escala de tonos para que la
/// app se vea coherente en modo claro y oscuro.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ColorScheme _esquema(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    if (brightness == Brightness.dark) {
      return base.copyWith(
        primary: const Color(0xFF6EA2FF),
        onPrimary: const Color(0xFF0B1330),
        primaryContainer: const Color(0xFF1B3A7A),
        onPrimaryContainer: const Color(0xFFDCE7FF),
        surface: AppColors.navy,
        onSurface: const Color(0xFFE8ECF8),
        onSurfaceVariant: const Color(0xFFA9B4D3),
        surfaceContainerLowest: const Color(0xFF080E26),
        surfaceContainerLow: const Color(0xFF121B3F), // tarjetas
        surfaceContainer: const Color(0xFF16204A),
        surfaceContainerHigh: const Color(0xFF1A2655), // diálogos y hojas
        surfaceContainerHighest: const Color(0xFF223164), // campos y chips
        outline: const Color(0xFF5A6A9E),
        outlineVariant: const Color(0xFF2B3A6E),
        error: const Color(0xFFFF6B6B),
      );
    }
    return base.copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFDCE8FF),
      onPrimaryContainer: const Color(0xFF0B2A66),
      surface: AppColors.lightBg,
      onSurface: const Color(0xFF111A33),
      onSurfaceVariant: const Color(0xFF51607F),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Colors.white, // tarjetas
      surfaceContainer: const Color(0xFFF8FAFE),
      surfaceContainerHigh: Colors.white, // diálogos y hojas
      surfaceContainerHighest: const Color(0xFFE9EFFA), // campos y chips
      outline: const Color(0xFF8793B0),
      outlineVariant: const Color(0xFFD6DEEE),
    );
  }

  static ThemeData _build(Brightness brightness) {
    final scheme = _esquema(brightness);
    final oscuro = brightness == Brightness.dark;
    final borde = BorderSide(color: scheme.outlineVariant);
    RoundedRectangleBorder forma(double r, {BorderSide side = BorderSide.none}) =>
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r),
          side: side,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
    );
    final texto = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    OutlineInputBorder campo(Color color, [double ancho = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: ancho),
        );

    return base.copyWith(
      textTheme: texto,
      // Transparente: detrás se ve la imagen de fondo (FondoApp).
      scaffoldBackgroundColor: Colors.transparent,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: texto.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        elevation: oscuro ? 0 : 1,
        margin: const EdgeInsets.symmetric(vertical: 4),
        clipBehavior: Clip.antiAlias,
        shape: forma(16, side: borde),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: forma(16),
        subtitleTextStyle: texto.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: forma(24, side: borde),
        titleTextStyle: texto.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        contentTextStyle: texto.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        modalBackgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 0,
        backgroundColor: oscuro ? const Color(0xFF0E1635) : Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: oscuro ? 0.22 : 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((estados) {
          final activo = estados.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
            color: activo ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((estados) {
          final activo = estados.contains(WidgetState.selected);
          return IconThemeData(
            color: activo ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: oscuro ? const Color(0xFF0E1635) : Colors.white,
        indicatorColor: scheme.primary.withValues(alpha: oscuro ? 0.22 : 0.14),
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: oscuro
            ? const Color(0xFF0F1738)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: campo(scheme.outlineVariant),
        enabledBorder: campo(scheme.outlineVariant),
        focusedBorder: campo(scheme.primary, 1.6),
        errorBorder: campo(scheme.error),
        focusedErrorBorder: campo(scheme.error, 1.6),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: scheme.primary),
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
        ),
        helperStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: scheme.primary.withValues(alpha: oscuro ? 0.24 : 0.14),
        checkmarkColor: scheme.primary,
        side: borde,
        shape: forma(12),
        labelStyle: texto.labelLarge?.copyWith(color: scheme.onSurface),
        secondaryLabelStyle: texto.labelLarge?.copyWith(color: scheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        showCheckmark: true,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(borde),
          backgroundColor: WidgetStateProperty.resolveWith((estados) {
            return estados.contains(WidgetState.selected)
                ? scheme.primary.withValues(alpha: oscuro ? 0.24 : 0.14)
                : scheme.surfaceContainerLow;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((estados) {
            return estados.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurface;
          }),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52), // zona táctil cómoda
          shape: forma(14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: forma(14),
          side: BorderSide(color: scheme.outline),
          backgroundColor: scheme.surfaceContainerLow,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: forma(12),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 3,
        extendedTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        shape: forma(16),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: oscuro ? const Color(0xFF2A3A72) : const Color(0xFF1B2547),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        actionTextColor: const Color(0xFF9CC0FF),
        shape: forma(12),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 6,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: forma(14, side: borde),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: forma(24),
      ),
    );
  }
}
