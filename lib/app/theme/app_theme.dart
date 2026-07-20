import 'package:flutter/material.dart';
import 'package:uakyt/app/theme/app_color_scheme.dart';
import 'package:uakyt/app/theme/app_text_theme.dart';

class AppTheme {
  static const String fontFamily = 'Rubik';

  static final ThemeData light = _buildTheme(AppColorScheme.light);
  static final ThemeData dark = _buildTheme(AppColorScheme.dark);

  static ThemeData _buildTheme(ColorScheme scheme) {
    final TextTheme textTheme = appTextTheme.apply(
      fontFamily: fontFamily,
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      decorationColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: scheme,
      brightness: scheme.brightness,
      textTheme: textTheme,
      appBarTheme: AppBarThemeData(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        backgroundColor: scheme.surface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface, size: 24.0, fill: 1.0),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStateColor.fromMap({
            WidgetState.selected: scheme.primary,
            ~WidgetState.selected: scheme.onSurface,
          }),
          backgroundColor: WidgetStateColor.fromMap({
            WidgetState.selected: scheme.primary,
            WidgetState.pressed: scheme.onSurface.withAlpha(0x42),
            WidgetState.hovered: scheme.onSurface.withAlpha(0x28),
            WidgetState.focused: scheme.onSurface.withAlpha(0x28),
            WidgetState.any: Colors.transparent,
          }),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.fromMap({
            WidgetState.selected: scheme.onSurface,
            WidgetState.pressed: scheme.surface.withAlpha(0x42),
            WidgetState.hovered: scheme.surface.withAlpha(0x28),
            WidgetState.focused: scheme.surface.withAlpha(0x28),
            WidgetState.any: scheme.onSurface,
          }),
          backgroundColor: WidgetStateColor.fromMap({
            WidgetState.selected: scheme.primary,
            WidgetState.pressed: scheme.surface.withAlpha(0x42),
            WidgetState.hovered: scheme.surface.withAlpha(0x28),
            WidgetState.focused: scheme.surface.withAlpha(0x28),
            WidgetState.any: scheme.surface,
          }),
        ),
      ),
      highlightColor: scheme.onSurface.withAlpha(0x16),
    );
  }
}
