import 'package:flutter/material.dart'
    show
        ThemeMode,
        Brightness,
        ValueNotifier,
        Color,
        View,
        BuildContext,
        WidgetsBinding;

import '../../../app/extensions/value_notifier.extension.dart';
import '../states/theme_manager.state.dart';

class ThemeManagerStore extends ValueNotifier<ThemeManagerState> {
  ThemeManagerStore() : super(const ThemeManager());

  set themeMode(ThemeMode themeMode) {
    if (state.themeMode == themeMode) return;

    state = state.copyWith(
      themeMode: themeMode,
    );
  }

  ThemeMode get themeMode => state.themeMode!;

  set brightness(Brightness brightness) {
    if (state.brightness == brightness) return;

    state = state.copyWith(
      brightness: brightness,
    );
  }

  Brightness get brightness => state.brightness!;

  set accentColor(Color color) {
    if (state.accentColor == color) return;

    state = state.copyWith(
      accentColor: color,
    );
  }

  Color get accentColor => state.accentColor!;

  Brightness getBrightness(BuildContext context) {
    switch (state.themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      default:
        return View.of(context).platformDispatcher.platformBrightness;
    }
  }

  void handlePlatformBrightnessChanged(BuildContext context) {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      if (themeMode == ThemeMode.system) {
        brightness = View.of(context).platformDispatcher.platformBrightness;
      }
    };
  }
}
