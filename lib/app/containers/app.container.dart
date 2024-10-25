import 'package:flutter/widgets.dart';
import '../../features/theme_manager/stores/theme_manager.store.dart';
import '../../features/translate_manager/stores/translate_manager.store.dart';
import '../stores/app.store.dart';

@immutable
class AppContainer extends InheritedWidget {
  final AppStore appStore;
  final ThemeManagerStore themeManagerStore;
  final TranslateManagerStore translateManagerStore;

  const AppContainer({
    super.key,
    required super.child,
    required this.appStore,
    required this.themeManagerStore,
    required this.translateManagerStore,
  });

  @override
  bool updateShouldNotify(covariant AppContainer oldWidget) {
    return appStore != oldWidget.appStore ||
        themeManagerStore != oldWidget.themeManagerStore ||
        translateManagerStore != oldWidget.translateManagerStore;
  }

  static AppContainer of(BuildContext context) {
    final AppContainer? result =
        context.dependOnInheritedWidgetOfExactType<AppContainer>();

    assert(result != null, 'No AppContainer found in context');
    return result!;
  }
}
