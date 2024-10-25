import 'package:flutter/widgets.dart';

import '../stores/animated_button.store.dart';

@immutable
class AnimatedButtonContainer extends InheritedWidget {
  final AnimatedButtonStore animatedButtonStore;

  const AnimatedButtonContainer({
    super.key,
    required super.child,
    required this.animatedButtonStore,
  });

  @override
  bool updateShouldNotify(covariant AnimatedButtonContainer oldWidget) {
    return animatedButtonStore != oldWidget.animatedButtonStore;
  }
}
