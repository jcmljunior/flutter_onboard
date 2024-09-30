import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/overview/constants/overview.constant.dart';
import 'package:flutter_onboard/features/overview/containers/overview.container.dart';
import 'package:flutter_onboard/features/overview/models/overview_item.model.dart';

@immutable
class OverviewButtonWidget extends StatefulWidget {
  const OverviewButtonWidget({super.key});

  @override
  State<OverviewButtonWidget> createState() => _OverviewButtonWidgetState();
}

class _OverviewButtonWidgetState extends State<OverviewButtonWidget>
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
      duration: const Duration(
          milliseconds: OverviewConstant.defaultFabAnimationDuration),
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
        OverviewContainer.of(context).overviewStore.value.currentIndex!;
    final List<OverviewItemModel> overviewItems =
        OverviewContainer.of(context).overviewStore.value.overviewItems!;
    final AnimationController imageController = OverviewContainer.of(context)
        .imageControllers
        .entries
        .elementAt(currentIndex)
        .value;

    if (currentIndex == overviewItems.length - 1 &&
        !imageController.isAnimating) {
      fabController.forward();
      return;
    }

    fabController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        fabController,
        OverviewContainer.of(context).overviewStore,
        OverviewContainer.of(context)
            .imageControllers
            .entries
            .elementAt(OverviewContainer.of(context)
                    .overviewStore
                    .value
                    .overviewItems!
                    .length -
                1)
            .value
      ]),
      builder: (BuildContext context, Widget? _) {
        fabAnimationHandler();

        return AnimatedSwitcher(
          duration: const Duration(
            milliseconds: OverviewConstant.defaultFabAnimationDuration ~/ 20,
          ),
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.fastOutSlowIn,
          child: SlideTransition(
            position: fabAnimation,
            child: FloatingActionButton(
              elevation: 1.0,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }
}
