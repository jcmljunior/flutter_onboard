import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';

class NextPageButton extends StatelessWidget {
  final String pathFor;

  const NextPageButton({
    super.key,
    required this.pathFor,
  });

  AnimationController? getLastAnimationController(BuildContext context) {
    final imageController = OnboardContainer.of(context)
        .imageControllers
        .entries
        .where((imageController) =>
            imageController.key ==
            OnboardContainer.of(context).pages.last.runtimeType.toString());

    assert(imageController.isNotEmpty);
    return imageController.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        OnboardContainer.of(context).onboardStore,
        getLastAnimationController(context),
      ]),
      builder: (BuildContext context, Widget? _) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 450),
          opacity: OnboardContainer.of(context).onboardStore.value.pageIndex ==
                      OnboardContainer.of(context).pages.length - 1 &&
                  getLastAnimationController(context)!.isCompleted
              ? 1.0
              : 0.0,
          child: FloatingActionButton(
            elevation: 1.0,
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(pathFor);
            },
            child: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
