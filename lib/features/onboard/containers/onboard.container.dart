import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_store.provider.dart';

@immutable
class OnboardContainer extends InheritedWidget {
  final OnboardStore onboardStore;
  final TabController tabController;
  final PageController pageController;
  final List<Widget> pages;

  const OnboardContainer({
    super.key,
    required super.child,
    required this.onboardStore,
    required this.tabController,
    required this.pageController,
    required this.pages,
  });

  @override
  bool updateShouldNotify(OnboardContainer oldWidget) =>
      tabController != oldWidget.tabController ||
      pageController != oldWidget.pageController ||
      pages != oldWidget.pages;

  static OnboardContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OnboardContainer>()!;
}
