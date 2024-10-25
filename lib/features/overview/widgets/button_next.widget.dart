import 'package:flutter/material.dart';

import '../containers/overview.container.dart';

@immutable
class ButtonNextWidget extends StatefulWidget {
  const ButtonNextWidget({super.key});

  @override
  State<ButtonNextWidget> createState() => _ButtonNextWidgetState();
}

class _ButtonNextWidgetState extends State<ButtonNextWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabController;
  late final Animation<Offset> fabAnimation;

  @override
  void initState() {
    super.initState();

    setFabController();
    setFabAnimation();
  }

  @override
  void dispose() {
    fabController.dispose();

    super.dispose();
  }

  void setFabController() {
    fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  void setFabAnimation() {
    fabAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: fabController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void fabAnimationHandler() {
    final int currentIndex =
        OverviewContainer.of(context).pageController.page?.round() ?? 0;
    final int lastIndex =
        OverviewContainer.of(context).overviewStore.overviewItems.length - 1;

    if (currentIndex == lastIndex) {
      fabController.forward();
      return;
    }

    fabController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: OverviewContainer.of(context).pageController,
      builder: (BuildContext context, Widget? _) {
        fabAnimationHandler();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.fastOutSlowIn,
          child: SlideTransition(
            position: fabAnimation,
            child: FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/teste'),
              child: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }
}
