import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ValueListenableBuilder<OnboardState>(
        valueListenable: OnboardContainer.of(context).onboardStore,
        builder: (BuildContext context, OnboardState state, Widget? _) {
          return Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: List.generate(
              OnboardContainer.of(context).pages.length,
              (int index) => AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.fastOutSlowIn,
                width: index ==
                        OnboardContainer.of(context)
                            .onboardStore
                            .value
                            .pageIndex
                    ? 24.0
                    : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: index ==
                          OnboardContainer.of(context)
                              .onboardStore
                              .value
                              .pageIndex
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
