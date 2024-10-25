import 'package:flutter/widgets.dart';

import '../../../core/dialog/stores/dialog.store.dart';

@immutable
class ChooseLanguageContainer extends InheritedWidget {
  final DialogStore dialogStore;

  const ChooseLanguageContainer({
    super.key,
    required super.child,
    required this.dialogStore,
  });

  @override
  bool updateShouldNotify(covariant ChooseLanguageContainer oldWidget) {
    return dialogStore != oldWidget.dialogStore;
  }

  static ChooseLanguageContainer of(BuildContext context) {
    final ChooseLanguageContainer? result =
        context.dependOnInheritedWidgetOfExactType<ChooseLanguageContainer>();

    assert(result != null, 'No ChooseLanguageContainer found in context');
    return result!;
  }
}
