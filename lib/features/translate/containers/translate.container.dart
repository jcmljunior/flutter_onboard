import 'package:flutter/widgets.dart';
import 'package:flutter_onboard/features/translate/providers/translate_manager_store.provider.dart';

@immutable
class TranslateContainer extends InheritedWidget {
  final TranslateManagerStoreProvider translateManagerStoreProvider =
      TranslateManagerStoreProvider();

  TranslateContainer({
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant TranslateContainer oldWidget) {
    return true;
  }

  Function(String key, {List<String>? replacements})
      get fetchLocalizedStrings =>
          translateManagerStoreProvider.fetchLocalizedStrings;

  static TranslateContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TranslateContainer>()!;
}
