import 'package:flutter/foundation.dart';

import '../states/animated_button.state.dart';

class AnimatedButtonStore extends ValueNotifier<AnimatedButtonState> {
  AnimatedButtonStore() : super(const AnimatedButton());

  set isShowing(bool isShowing) {
    value = value.copyWith(
      isShowing: isShowing,
    );
  }

  bool get isShowing => value.isShowing!;

  void toggleIsShowing() {
    isShowing = !isShowing;
  }
}
