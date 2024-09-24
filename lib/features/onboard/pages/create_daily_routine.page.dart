import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/partials/colorize.partial.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

part '../partials/colorize_create_daily_routine.partial.dart';

@immutable
class CreateDailyRoutine extends StatefulWidget {
  const CreateDailyRoutine({super.key});

  @override
  State<CreateDailyRoutine> createState() => _CreateDailyRoutineState();
}

class _CreateDailyRoutineState extends State<CreateDailyRoutine> {
  String get animationName => 'CreateDailyRoutine';

  AnimationController? get animationController =>
      OnboardContainer.of(context).imageControllers['CreateDailyRoutine'];

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
        'assets/images/intro/create_daily_routine.svg',
        colorMapper: ColorizeCreateDailyRoutine(
          targetColors: const [
            // Afeta a cor do botão, da blusa e dos circulos presente no calendário da figura.
            Color(0xff6c63ff),

            // Afeta a cor de preenchimento do calendário.
            // Color(0xfff1f1f1),

            // Afeta a cor dos circulos do calendário.
            // Color(0xff3f3d56),

            // Afeta a cor dos ícones direcionais no cabecalho do calendário.
            // Color(0xffe6e6e6),

            // Afeta a cor ícone do botão.
            // Color(0xffffffff),
          ],
          replacementColors: [
            Theme.of(context).colorScheme.primary,
            // Theme.of(context).colorScheme.surfaceContainerLow,
            // Theme.of(context).colorScheme.secondaryContainer,
            // Theme.of(context).colorScheme.surfaceContainerHighest,
            // Theme.of(context).colorScheme.inversePrimary,
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
                    'Create daily routine',
                    style: Theme.of(context).textTheme.headlineLarge!,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'In Uptodo  you can create your personalized routine to stay productive.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
