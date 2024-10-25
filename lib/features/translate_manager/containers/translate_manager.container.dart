import 'package:flutter/widgets.dart';
import '../stores/translate_manager.store.dart';

@immutable
class TranslateManagerContainer extends InheritedWidget {
  final TranslateManagerStore translateManagerStore;

  const TranslateManagerContainer({
    super.key,
    required super.child,
    required this.translateManagerStore,
  });

  @override
  bool updateShouldNotify(covariant TranslateManagerContainer oldWidget) {
    return translateManagerStore != oldWidget.translateManagerStore;
  }

  static TranslateManagerContainer of(BuildContext context) {
    final TranslateManagerContainer? result =
        context.dependOnInheritedWidgetOfExactType<TranslateManagerContainer>();

    assert(result != null, 'No TranslateManagerContainer found in context');
    return result!;
  }
}
