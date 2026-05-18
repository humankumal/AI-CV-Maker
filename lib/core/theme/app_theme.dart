import 'package:flutter/material.dart';

import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFF5F5F5),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFF666666),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF0F0F0),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFF444444),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFEEEEEE),
      onTertiaryContainer: Color(0xFF000000),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFAFAFA),
      surfaceContainer: Color(0xFFF5F5F5),
      surfaceContainerHigh: Color(0xFFEEEEEE),
      surfaceContainerHighest: Color(0xFFE8E8E8),
      onSurfaceVariant: Color(0xFF666666),
      outline: Color(0xFFE0E0E0),
      outlineVariant: Color(0xFFE0E0E0),
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      inverseSurface: Color(0xFF1A1A1A),
      onInverseSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFFFFFFFF),
      scrim: Color(0xFF000000),
      shadow: Color(0xFF000000),
    );
    return _build(scheme, Brightness.light);
  }

  static ThemeData dark() {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF1A1A1A),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFFAAAAAA),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF2A2A2A),
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF888888),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF222222),
      onTertiaryContainer: Color(0xFFFFFFFF),
      surface: Color(0xFF0A0A0A),
      onSurface: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF111111),
      surfaceContainer: Color(0xFF1A1A1A),
      surfaceContainerHigh: Color(0xFF222222),
      surfaceContainerHighest: Color(0xFF2A2A2A),
      onSurfaceVariant: Color(0xFFAAAAAA),
      outline: Color(0xFF333333),
      outlineVariant: Color(0xFF2A2A2A),
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF8C0009),
      onErrorContainer: Color(0xFFFFDAD6),
      inverseSurface: Color(0xFFFFFFFF),
      onInverseSurface: Color(0xFF000000),
      inversePrimary: Color(0xFF000000),
      scrim: Color(0xFF000000),
      shadow: Color(0xFF000000),
    );
    return _build(scheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final TextTheme text = AppTypography.textTheme(brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: scheme.outline),
        ),
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: 0.5,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurface,
      ),
    );
  }
}
