import 'package:flutter/material.dart';

@immutable
sealed class ThemeState {
  final ThemeMode? themeMode;

  const ThemeState({
    this.themeMode,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
  });
}

class ThemeStateInitial extends ThemeState {
  const ThemeStateInitial({
    themeMode,
  }) : super(
          themeMode: ThemeMode.system,
        );

  @override
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeStateInitial(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
