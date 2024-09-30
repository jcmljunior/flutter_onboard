import 'package:flutter/material.dart' show immutable, ThemeMode, Color, Colors;

@immutable
sealed class ThemeStateProvider {
  final ThemeMode? themeMode;
  final Color? accentColor;

  const ThemeStateProvider({
    this.themeMode,
    this.accentColor,
  });

  ThemeStateProvider copyWith({
    ThemeMode? themeMode,
    Color? accentColor,
  });
}

class ThemeState extends ThemeStateProvider {
  const ThemeState({
    ThemeMode? themeMode,
    Color? accentColor,
  }) : super(
          themeMode: themeMode ?? ThemeMode.system,
          accentColor: accentColor ?? Colors.indigo,
        );

  @override
  ThemeStateProvider copyWith({
    ThemeMode? themeMode,
    Color? accentColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
