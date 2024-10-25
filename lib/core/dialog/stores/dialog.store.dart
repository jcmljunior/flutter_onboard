import 'package:flutter/foundation.dart';

import '../../../app/extensions/value_notifier.extension.dart';
import '../states/dialog.state.dart';

class DialogStore extends ValueNotifier<DialogState> {
  DialogStore() : super(DialogWidget());

  set isShowing(bool isShowing) => state = state.copyWith(isShowing: isShowing);

  bool get isShowing => value.isShowing!;

  void toggleIsShowing() => isShowing = !isShowing;
}
