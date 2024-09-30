import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/overview/constants/overview.constant.dart';
import 'package:flutter_onboard/features/overview/containers/overview.container.dart';
import 'package:flutter_onboard/features/overview/providers/overview_state.provider.dart';
import 'package:flutter_onboard/features/overview/providers/overview_store.provider.dart';
import 'package:flutter_onboard/features/overview/widgets/overview_button.widget.dart';
import 'package:flutter_onboard/features/theme/containers/theme.container.dart';
import 'package:flutter_onboard/features/theme/mixins/color_toolkit.mixin.dart';
import 'package:flutter_onboard/features/translate/containers/translate.container.dart';
import 'package:flutter_svg/flutter_svg.dart';

@immutable
class Colorize extends ColorMapper {
  final List<Color> targetColors;
  final List<Color> replacementColors;

  const Colorize({
    required this.targetColors,
    required this.replacementColors,
  });

  @override
  Color substitute(
      String? id, String elementName, String attributeName, Color color) {
    for (int i = 0; i < targetColors.length; i++) {
      if (color == targetColors[i]) {
        return replacementColors[i];
      }
    }

    return color;
  }
}

@immutable
class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with TickerProviderStateMixin, ColorToolkit {
  late final OverviewStore overviewStore;
  late final TabController tabController;
  late final PageController pageController;
  late final Map<String, AnimationController> imageControllers;

  @override
  void initState() {
    super.initState();

    setOverviewStore();
    setTabController();
    setPageController();
    setImageControllers();

    overviewStore.addListener(() {
      imageAnimationHandler(overviewStore.value.currentIndex!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      imageAnimationHandler(overviewStore.value.currentIndex!);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();

    for (final imageController in imageControllers.values) {
      imageController.dispose();
    }

    super.dispose();
  }

  void setOverviewStore() {
    overviewStore = OverviewStore();
  }

  void setTabController() {
    tabController = TabController(
      length: overviewStore.value.overviewItems!.length,
      vsync: this,
    );
  }

  void setPageController() {
    pageController = PageController(
      initialPage: 0,
    );
  }

  void setImageControllers() {
    imageControllers = {
      for (final item in overviewStore.value.overviewItems!)
        item.title!: AnimationController(
          vsync: this,
          duration: const Duration(
              milliseconds: OverviewConstant.defaultImageAnimationDuration),
        ),
    };
  }

  void startAnimation(int index) {
    imageControllers.values.elementAt(index).forward();
  }

  void stopAnimation(int index) {
    imageControllers.values.elementAt(index).reverse();
  }

  void imageAnimationHandler(int currentIndex) {
    for (int i = 0; i < imageControllers.length; i++) {
      if (currentIndex == i) {
        startAnimation(i);
      } else {
        stopAnimation(i);
      }
    }
  }

  Widget pagingIndicator() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder<OverViewStateProvider>(
        valueListenable: overviewStore,
        builder:
            (BuildContext context, OverViewStateProvider state, Widget? _) {
          return Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: List.generate(
              state.overviewItems!.length,
              (int index) => AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.fastOutSlowIn,
                width: index ==
                        OverviewContainer.of(context)
                            .overviewStore
                            .value
                            .currentIndex
                    ? 24.0
                    : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: index == overviewStore.value.currentIndex
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

  @override
  Widget build(BuildContext context) {
    return OverviewContainer(
      overviewStore: overviewStore,
      imageControllers: imageControllers,
      tabController: tabController,
      pageController: pageController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Skip'),
            ),
          ],
        ),
        floatingActionButton: const OverviewButtonWidget(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      overviewStore,
                      TranslateContainer.of(context)
                          .translateManagerStoreProvider,
                      ThemeContainer.of(context).themeStore,
                    ]),
                    builder: (BuildContext context, Widget? _) {
                      return PageView(
                        controller: pageController,
                        onPageChanged: overviewStore.onPageChanged,
                        children: List.generate(
                          overviewStore.value.overviewItems!.length,
                          (int index) {
                            return SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.center,
                                runSpacing: 24.0,
                                children: [
                                  if (imageControllers.isNotEmpty)
                                    ValueListenableBuilder<
                                        OverViewStateProvider>(
                                      valueListenable: overviewStore,
                                      builder: (BuildContext context,
                                          OverViewStateProvider state,
                                          Widget? _) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ScaleTransition(
                                            scale: imageControllers.entries
                                                .elementAt(index)
                                                .value
                                                .drive(
                                                  CurveTween(
                                                      curve: Curves
                                                          .easeInOutCubic),
                                                ),
                                            child: SvgPicture(
                                              width: 280.0,
                                              SvgAssetLoader(
                                                overviewStore
                                                    .getImageByIndex(index),
                                                colorMapper: Colorize(
                                                  targetColors: const [
                                                    Color(0xff6c63ff),
                                                  ],
                                                  replacementColors: [
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ],
                                                ),
                                              ),
                                            ),
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
                                          overviewStore.getTitleByIndex(
                                              context, index),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          overviewStore.getDescriptionByIndex(
                                              context, index),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                      if (overviewStore
                                          .getImageByIndex(index)
                                          .contains("personalize_your_color"))
                                        Container(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: List.generate(
                                              OverviewConstant
                                                  .accentColors.length,
                                              (int index) {
                                                return InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    16.0,
                                                  ),
                                                  onTap: () {
                                                    ThemeContainer.of(context)
                                                        .themeStore
                                                        .setAccentColor(
                                                            OverviewConstant
                                                                .accentColors
                                                                .entries
                                                                .elementAt(
                                                                    index)
                                                                .value);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: CircleAvatar(
                                                      radius: 16.0,
                                                      backgroundColor: darken(
                                                          OverviewConstant
                                                              .accentColors
                                                              .entries
                                                              .elementAt(index)
                                                              .value,
                                                          0.2),
                                                      child: CircleAvatar(
                                                          radius: 13.0,
                                                          backgroundColor:
                                                              darken(
                                                            OverviewConstant
                                                                .accentColors
                                                                .entries
                                                                .elementAt(
                                                                    index)
                                                                .value,
                                                            0.1,
                                                          ),
                                                          child: OverviewConstant
                                                                      .accentColors
                                                                      .entries
                                                                      .elementAt(
                                                                          index)
                                                                      .value ==
                                                                  ThemeContainer.of(
                                                                          context)
                                                                      .themeStore
                                                                      .value
                                                                      .accentColor
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  size: 24.0,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              : const SizedBox
                                                                  .shrink()),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              pagingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
