// The dynamic_color plugin currently exposes CorePalette/Scheme as its stable
// Android bridge. The deprecated API is isolated here until that plugin moves
// to DynamicScheme in a compatible release.
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;

final class AppTheme {
  const AppTheme._();

  static const fallbackSeedColor = Color(0xFFC62828);

  static ThemeData light({mcu.CorePalette? dynamicPalette}) {
    return _theme(Brightness.light, dynamicPalette: dynamicPalette);
  }

  static ThemeData dark({mcu.CorePalette? dynamicPalette}) {
    return _theme(Brightness.dark, dynamicPalette: dynamicPalette);
  }

  static ThemeData _theme(
    Brightness brightness, {
    mcu.CorePalette? dynamicPalette,
  }) {
    final scheme =
        (dynamicPalette == null
            ? null
            : _dynamicColorScheme(dynamicPalette, brightness)) ??
        ColorScheme.fromSeed(
          seedColor: fallbackSeedColor,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.expressive,
        );
    final textTheme = Typography.material2021().black.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: scheme.surfaceContainerHigh,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
        ),
        actionTextColor: scheme.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
    );
  }

  static ColorScheme _dynamicColorScheme(
    mcu.CorePalette palette,
    Brightness brightness,
  ) {
    final dynamicScheme = brightness == Brightness.light
        ? mcu.Scheme.lightFromCorePalette(palette)
        : mcu.Scheme.darkFromCorePalette(palette);

    return ColorScheme.fromSeed(
      seedColor: Color(dynamicScheme.primary),
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    ).copyWith(
      primary: Color(dynamicScheme.primary),
      onPrimary: Color(dynamicScheme.onPrimary),
      primaryContainer: Color(dynamicScheme.primaryContainer),
      onPrimaryContainer: Color(dynamicScheme.onPrimaryContainer),
      secondary: Color(dynamicScheme.secondary),
      onSecondary: Color(dynamicScheme.onSecondary),
      secondaryContainer: Color(dynamicScheme.secondaryContainer),
      onSecondaryContainer: Color(dynamicScheme.onSecondaryContainer),
      tertiary: Color(dynamicScheme.tertiary),
      onTertiary: Color(dynamicScheme.onTertiary),
      tertiaryContainer: Color(dynamicScheme.tertiaryContainer),
      onTertiaryContainer: Color(dynamicScheme.onTertiaryContainer),
      error: Color(dynamicScheme.error),
      onError: Color(dynamicScheme.onError),
      errorContainer: Color(dynamicScheme.errorContainer),
      onErrorContainer: Color(dynamicScheme.onErrorContainer),
      surface: Color(dynamicScheme.surface),
      onSurface: Color(dynamicScheme.onSurface),
      surfaceVariant: Color(dynamicScheme.surfaceVariant),
      onSurfaceVariant: Color(dynamicScheme.onSurfaceVariant),
      outline: Color(dynamicScheme.outline),
      outlineVariant: Color(dynamicScheme.outlineVariant),
      shadow: Color(dynamicScheme.shadow),
      scrim: Color(dynamicScheme.scrim),
      inverseSurface: Color(dynamicScheme.inverseSurface),
      onInverseSurface: Color(dynamicScheme.inverseOnSurface),
      inversePrimary: Color(dynamicScheme.inversePrimary),
      surfaceTint: Color(dynamicScheme.primary),
    );
  }
}
