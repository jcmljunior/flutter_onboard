import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/overview/providers/overview_store.provider.dart';

@immutable
class OverviewContainer extends InheritedWidget {
  final OverviewStore overviewStore;
  final TabController tabController;
  final PageController pageController;
  final Map<String, AnimationController> imageControllers;

  const OverviewContainer({
    super.key,
    required super.child,
    required this.overviewStore,
    required this.tabController,
    required this.pageController,
    required this.imageControllers,
  });

  @override
  bool updateShouldNotify(OverviewContainer oldWidget) =>
      tabController != oldWidget.tabController ||
      pageController != oldWidget.pageController ||
      imageControllers != oldWidget.imageControllers ||
      overviewStore != oldWidget.overviewStore;

  static OverviewContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OverviewContainer>()!;
}
