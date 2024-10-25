import 'package:flutter/material.dart';

import '../containers/overview.container.dart';

class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        OverviewContainer.of(context).pageController;
    final int pageCount = OverviewContainer.of(context).tabController.length;

    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      child: AnimatedBuilder(
        animation: pageController,
        builder: (BuildContext context, Widget? child) {
          final int currentPage = pageController.page?.round() ?? 0;

          return Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: List.generate(
              pageCount,
              (int index) => AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.fastOutSlowIn,
                width: index == currentPage ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: index == currentPage
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
