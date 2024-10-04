import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/theme_manager/containers/theme_manager.container.dart';
import 'package:flutter_onboard/features/theme_manager/states/theme_manager.state.dart';

class ThemeManagerStore extends ValueNotifier<ThemeManagerState> {
  ThemeManagerStore() : super(const ThemeManager());

  ThemeManagerState get state => super.value;

  set themeMode(ThemeMode themeMode) {
    value = value.copyWith(
      themeMode: themeMode,
    );
  }

  ThemeMode get themeMode => value.themeMode!;

  set accentColor(Color color) {
    value = value.copyWith(
      accentColor: color,
    );
  }

  Color get accentColor => value.accentColor!;

  Brightness getBrightness(BuildContext context) {
    switch (value.themeMode) {
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
      if (ThemeManagerContainer.of(context).themeManagerStore.themeMode ==
          ThemeMode.system) {
        themeMode = ThemeMode.system;
      }
    };
  }
}
