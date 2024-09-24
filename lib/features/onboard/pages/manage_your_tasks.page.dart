import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/partials/colorize.partial.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

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
            // Cor da blusa e ponteiros.
            // Color(0xff3f3d56),

            // Cor de preenchimento interna do relógio.
            Color(0xff6c63ff),

            // Cor de preenchimento da base dos ponteiros.
            // Color(0xffcccccc),

            // Cor de preenchimento externa do relógio.
            // Color(0xffe6e6e6),

            // Objeto nas costa do personagem.
            // Color(0xfff2f2f2),

            // Cor de preenchimento borda interna do relógio.
            // Color(0xffffffff),
          ],
          replacementColors: [
            // Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primary,
            // Theme.of(context).colorScheme.surfaceContainerHigh,
            // Theme.of(context).colorScheme.secondaryContainer,
            // Theme.of(context).colorScheme.surfaceContainerLow,
            // Theme.of(context).colorScheme.inverseSurface,
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
                    'Manage your tasks',
                    style: Theme.of(context).textTheme.headlineLarge!,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'You can easily manage all of your daily tasks in DoMe for free.',
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
