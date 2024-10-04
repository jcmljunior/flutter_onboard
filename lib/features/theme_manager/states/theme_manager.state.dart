import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/theme_manager/constants/theme_manager.constant.dart';

@immutable
sealed class ThemeManagerState {
  final ThemeMode? themeMode;
  final Color? accentColor;

  const ThemeManagerState({
    this.themeMode,
    this.accentColor,
  }) : assert(themeMode != null && accentColor != null);

  ThemeManagerState copyWith({
    ThemeMode? themeMode,
    Color? accentColor,
  });
}

class ThemeManager extends ThemeManagerState {
  const ThemeManager({
    ThemeMode? themeMode,
    Color? accentColor,
  }) : super(
          themeMode: themeMode ?? ThemeManagerConstant.defaultThemeMode,
          accentColor: accentColor ?? ThemeManagerConstant.defaultAccentColor,
        );

  @override
  ThemeManagerState copyWith({
    ThemeMode? themeMode,
    Color? accentColor,
  }) {
    return ThemeManager(
      themeMode: themeMode ?? this.themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor ?? this.accentColor,
    );
  }
}
