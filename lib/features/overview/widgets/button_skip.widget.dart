import 'package:flutter/material.dart';

import '../../translate_manager/containers/translate_manager.container.dart';
import '../containers/overview.container.dart';

@immutable
class ButtonSkipWidget extends StatefulWidget {
  const ButtonSkipWidget({super.key});

  @override
  State<ButtonSkipWidget> createState() => _ButtonSkipWidgetState();
}

class _ButtonSkipWidgetState extends State<ButtonSkipWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController buttonController;
  late final Animation<Offset> buttonAnimation;

  @override
  void initState() {
    super.initState();

    setButtonController();
    setButtonAnimation();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => buttonAnimationHandler(
        OverviewContainer.of(context),
      ),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();

    super.dispose();
  }

  void setButtonController() {
    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  void setButtonAnimation() {
    buttonAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2),
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void buttonAnimationHandler(OverviewContainer overviewContainer) {
    final int currentIndex =
        OverviewContainer.of(context).pageController.page?.round() ?? 0;
    final int lastIndex =
        OverviewContainer.of(context).overviewStore.overviewItems.length - 1;

    if (currentIndex == lastIndex) {
      buttonController.forward();
      return;
    }

    buttonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final OverviewContainer overviewContainer = OverviewContainer.of(context);
    final translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;

    return AnimatedBuilder(
      animation: overviewContainer.pageController,
      builder: (BuildContext context, Widget? child) {
        buttonAnimationHandler(overviewContainer);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.fastOutSlowIn,
          child: Visibility(
            visible: !buttonController.isCompleted,
            child: SlideTransition(
              position: buttonAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/teste'),
                  child: Text(
                    translateManagerStore
                        .fetchLocalizedStrings('overview.skip'),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
