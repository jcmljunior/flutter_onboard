import 'package:flutter/widgets.dart';
import 'package:flutter_onboard/features/welcome/providers/translate_manager_store.provider.dart';

class TranslateManager extends InheritedWidget {
  final TranslateManagerStore translateManagerStore = TranslateManagerStore();

  TranslateManager({
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant TranslateManager oldWidget) {
    return translateManagerStore != oldWidget.translateManagerStore;
  }

  static TranslateManager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TranslateManager>()!;

  TranslateManagerStore get store => translateManagerStore;

  Function(String key, {List<String>? args}) get translate =>
      translateManagerStore.translate;
}
