import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_store.provider.dart';

@immutable
class OnboardContainer extends InheritedWidget {
  final OnboardStore onboardStore;
  final TabController tabController;
  final PageController pageController;
  final Map<String, AnimationController> imageControllers;
  final List<Widget> pages;

  const OnboardContainer({
    super.key,
    required super.child,
    required this.onboardStore,
    required this.tabController,
    required this.pageController,
    required this.imageControllers,
    required this.pages,
  });

  @override
  bool updateShouldNotify(OnboardContainer oldWidget) =>
      tabController != oldWidget.tabController ||
      pageController != oldWidget.pageController ||
      pages != oldWidget.pages ||
      imageControllers != oldWidget.imageControllers;

  static OnboardContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OnboardContainer>()!;
}
