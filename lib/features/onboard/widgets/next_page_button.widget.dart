import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

class NextPageButton extends StatelessWidget {
  final String pathFor;

  const NextPageButton({
    super.key,
    required this.pathFor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<OnboardState>(
      valueListenable: OnboardContainer.of(context).onboardStore,
      builder: (BuildContext context, OnboardState state, Widget? _) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 450),
          opacity:
              state.pageIndex == OnboardContainer.of(context).pages.length - 1
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
