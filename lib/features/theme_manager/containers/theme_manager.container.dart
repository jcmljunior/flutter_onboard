import 'package:flutter/widgets.dart';

import '../stores/theme_manager.store.dart';

@immutable
class ThemeManagerContainer extends InheritedWidget {
  final ThemeManagerStore themeManagerStore;

  const ThemeManagerContainer({
    super.key,
    required super.child,
    required this.themeManagerStore,
  });

  @override
  bool updateShouldNotify(covariant ThemeManagerContainer oldWidget) {
    return themeManagerStore != oldWidget.themeManagerStore;
  }

  static ThemeManagerContainer of(BuildContext context) {
    final ThemeManagerContainer? result =
        context.dependOnInheritedWidgetOfExactType<ThemeManagerContainer>();

    assert(result != null, 'No ThemeManagerContainer found in context');
    return result!;
  }
}
