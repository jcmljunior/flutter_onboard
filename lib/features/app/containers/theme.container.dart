import 'package:flutter/widgets.dart';
import 'package:flutter_onboard/features/app/providers/theme_store.provider.dart';

@immutable
class ThemeContainer extends InheritedWidget {
  final ThemeStore themeStore = ThemeStore();

  ThemeContainer({
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(ThemeContainer oldWidget) =>
      themeStore != oldWidget.themeStore;

  static ThemeContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeContainer>()!;
}
