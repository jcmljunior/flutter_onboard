import 'package:flutter/material.dart'
    show immutable, Color, ThemeMode, Brightness;
import '../constants/theme_manager.constant.dart';

@immutable
sealed class ThemeManagerState {
  final ThemeMode? themeMode;
  final Brightness? brightness;
  final Color? accentColor;

  const ThemeManagerState({
    this.themeMode,
    this.brightness,
    this.accentColor,
  }) : assert(themeMode != null && brightness != null && accentColor != null);

  ThemeManagerState copyWith({
    ThemeMode? themeMode,
    Brightness? brightness,
    Color? accentColor,
  });
}

class ThemeManager extends ThemeManagerState {
  const ThemeManager({
    ThemeMode? themeMode,
    Brightness? brightness,
    Color? accentColor,
  }) : super(
          themeMode: themeMode ?? ThemeManagerConstant.defaultThemeMode,
          brightness: brightness ?? ThemeManagerConstant.defaultBrightness,
          accentColor: accentColor ?? ThemeManagerConstant.defaultAccentColor,
        );

  @override
  ThemeManagerState copyWith({
    ThemeMode? themeMode,
    Brightness? brightness,
    Color? accentColor,
  }) {
    return ThemeManager(
      themeMode: themeMode ?? this.themeMode ?? this.themeMode,
      brightness: brightness ?? this.brightness ?? this.brightness,
      accentColor: accentColor ?? this.accentColor ?? this.accentColor,
    );
  }
}
