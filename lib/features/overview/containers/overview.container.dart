import 'package:flutter/material.dart' show TabController;
import 'package:flutter/widgets.dart';

import '../stores/overview.store.dart';

@immutable
class OverviewContainer extends InheritedWidget {
  final OverviewStore overviewStore;
  final TabController tabController;
  final PageController pageController;
  final List<AnimationController> imageControllers;

  const OverviewContainer({
    super.key,
    required super.child,
    required this.overviewStore,
    required this.tabController,
    required this.pageController,
    required this.imageControllers,
  });

  @override
  bool updateShouldNotify(covariant OverviewContainer oldWidget) {
    return overviewStore != oldWidget.overviewStore ||
        tabController != oldWidget.tabController ||
        pageController != oldWidget.pageController ||
        imageControllers != oldWidget.imageControllers;
  }

  static OverviewContainer of(BuildContext context) {
    final OverviewContainer? result =
        context.dependOnInheritedWidgetOfExactType<OverviewContainer>();

    assert(result != null, 'No OverviewContainer found in context');
    return result!;
  }
}
