import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/app/containers/theme.container.dart';
import 'package:flutter_onboard/features/app/providers/theme_state.provider.dart';

class ThemeStore extends ValueNotifier<ThemeState> {
  ThemeStore() : super(const ThemeStateInitial());

  void handlePlatformBrightnessChanged(BuildContext context) {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      if (ThemeContainer.of(context).themeStore.value.themeMode ==
          ThemeMode.system) {
        setThemeMode(ThemeMode.system);
      }
    };
  }

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

  void setThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return setThemeLight();

      case ThemeMode.dark:
        return setThemeDark();

      default:
        return setThemeSystem();
    }
  }

  void setThemeSystem() {
    value = value.copyWith(
      themeMode: ThemeMode.system,
    );
  }

  void setThemeLight() {
    value = value.copyWith(
      themeMode: ThemeMode.light,
    );
  }

  void setThemeDark() {
    value = value.copyWith(
      themeMode: ThemeMode.dark,
    );
  }
}
