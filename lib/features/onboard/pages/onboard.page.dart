import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/pages/create_daily_routine.page.dart';
import 'package:flutter_onboard/features/onboard/pages/manage_your_tasks.page.dart';
import 'package:flutter_onboard/features/onboard/pages/organize_your_tasks.page.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_store.provider.dart';
import 'package:flutter_onboard/features/onboard/widgets/next_page_button.widget.dart';
import 'package:flutter_onboard/features/onboard/widgets/page_indicator.widget.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> with TickerProviderStateMixin {
  late final OnboardStore onboardStore;
  late final TabController tabController;
  late final PageController pageController;
  late final Map<String, AnimationController> imageControllers;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    setOnboardStore();
    setPages();
    setImageControllers();
    setTabController();
    setPageController();
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

  void setOnboardStore() {
    onboardStore = OnboardStore();
  }

  void setPages() {
    pages = const <Widget>[
      ManageYourTasks(),
      CreateDailyRoutine(),
      OrganizeYourTasks(),
    ];
  }

  void setTabController() {
    tabController = TabController(
      length: pages.length,
      vsync: this,
    );
  }

  void setPageController({int initialPage = 0}) {
    pageController = PageController(
      initialPage: initialPage,
    );
  }

  void setImageControllers() {
    imageControllers = {
      for (final Widget page in pages)
        page.runtimeType.toString(): AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 800),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return OnboardContainer(
      onboardStore: onboardStore,
      tabController: tabController,
      pageController: pageController,
      imageControllers: imageControllers,
      pages: pages,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: PageView(
                  controller: pageController,
                  onPageChanged: onboardStore.handlePageChanged,
                  children: pages,
                ),
              ),
            ),
            const PageIndicator(),
          ],
        ),
        floatingActionButton: const NextPageButton(
          pathFor: '/welcome',
        ),
      ),
    );
  }
}
