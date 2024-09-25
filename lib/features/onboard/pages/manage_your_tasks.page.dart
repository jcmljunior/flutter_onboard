import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/partials/colorize.partial.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';
import 'package:flutter_onboard/features/welcome/containers/translate_manager.container.dart';

part '../partials/colorize_manage_your_tasks.partial.dart';

@immutable
class ManageYourTasks extends StatefulWidget {
  const ManageYourTasks({super.key});

  @override
  State<ManageYourTasks> createState() => _ManageYourTasksState();
}

class _ManageYourTasksState extends State<ManageYourTasks> {
  String get animationName => 'ManageYourTasks';

  AnimationController? get animationController =>
      OnboardContainer.of(context).imageControllers['ManageYourTasks'];

  void startAnimation() {
    animationController!.forward();
  }

  void stopAnimation() {
    animationController!.reverse();
  }

  String getPageNameByIndex(int pageIndex) =>
      OnboardContainer.of(context).pages[pageIndex].runtimeType.toString();

  void handleAnimationController(int pageIndex) {
    for (var i = 0; i < OnboardContainer.of(context).pages.length; i++) {
      if (getPageNameByIndex(pageIndex) == animationName && pageIndex == i) {
        return startAnimation();
      }
    }

    stopAnimation();
  }

  Widget _buildPicture() {
    return SvgPicture(
      width: 280.0,
      SvgAssetLoader(
        'assets/images/intro/manage_your_tasks.svg',
        colorMapper: ColorizeCreateDailyRoutine(
          targetColors: const [
            Color(0xff6c63ff),
          ],
          replacementColors: [
            Theme.of(context).colorScheme.primary,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 24.0,
          children: [
            if (animationController != null)
              ValueListenableBuilder<OnboardState>(
                valueListenable: OnboardContainer.of(context).onboardStore,
                builder: (BuildContext context, OnboardState state, Widget? _) {
                  handleAnimationController(state.pageIndex!);

                  return SizedBox(
                    width: double.infinity,
                    child: ScaleTransition(
                      scale: animationController!.drive(
                        CurveTween(curve: Curves.easeInOutCubic),
                      ),
                      child: _buildPicture(),
                    ),
                  );
                },
              ),
            Wrap(
              runSpacing: 16.0,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    TranslateManager.of(context).translate(
                      'onboard/manage_your_tasks/title',
                    ),
                    style: Theme.of(context).textTheme.headlineLarge!,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    TranslateManager.of(context).translate(
                      'onboard/manage_your_tasks/subtitle',
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
