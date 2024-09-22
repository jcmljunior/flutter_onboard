import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';

mixin OnboardAnimations {
  void startAnimation(AnimationController controller) {
    controller.forward();
  }

  void stopAnimation(AnimationController controller) {
    controller.reverse();
  }

  void handleAnimationController(
      BuildContext context, AnimationController controller,
      {int pageIndex = 0}) {
    if (OnboardContainer.of(context).onboardStore.value.pageIndex ==
        pageIndex) {
      return startAnimation(controller);
    }

    stopAnimation(controller);
  }
}
