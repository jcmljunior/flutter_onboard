import 'package:flutter/material.dart';

class ThemeManagerConstant {
  static const ThemeMode defaultThemeMode = ThemeMode.system;
  static const Brightness defaultBrightness = Brightness.light;
  static const Color defaultAccentColor = Colors.green;

  static const bool defaultUseMaterial3 = true;
  static const String defaultFontFamily = 'Inter';
  static const double defaultBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double defaultElevation = 1.0;
  static const double defaultIconSize = 24.0;

  static const dialogTheme = DialogTheme(
    insetPadding: EdgeInsets.all(
      ThemeManagerConstant.defaultPadding,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          ThemeManagerConstant.defaultBorderRadius,
        ),
      ),
    ),
  );

  static var textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: ThemeManagerConstant.defaultPadding,
          vertical: ThemeManagerConstant.defaultPadding / 2,
        ),
      ),
      iconSize: WidgetStateProperty.all(
        ThemeManagerConstant.defaultIconSize,
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ThemeManagerConstant.defaultBorderRadius),
        ),
      ),
    ),
  );

  static var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: ThemeManagerConstant.defaultPadding,
          vertical: ThemeManagerConstant.defaultPadding / 2,
        ),
      ),
      iconSize: WidgetStateProperty.all(
        ThemeManagerConstant.defaultIconSize,
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ThemeManagerConstant.defaultBorderRadius),
        ),
      ),
    ),
  );

  static var floatingActionButtonTheme = FloatingActionButtonThemeData(
    elevation: ThemeManagerConstant.defaultElevation,
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(ThemeManagerConstant.defaultBorderRadius),
    ),
  );
}
