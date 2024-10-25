import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/constants/app.constant.dart';
import '../../colorize_vectors/colorize_vector.dart';
import '../../translate_manager/containers/translate_manager.container.dart';
import '../../translate_manager/stores/translate_manager.store.dart';
import '../containers/overview.container.dart';
import '../models/overview_item.model.dart';
import '../stores/overview.store.dart';
import '../widgets/button_back.widget.dart';
import '../widgets/button_next.widget.dart';
import '../widgets/button_skip.widget.dart';
import '../widgets/page_indicator.widget.dart';

@immutable
class OverviewWelcomePage extends StatefulWidget {
  const OverviewWelcomePage({super.key});

  @override
  State<OverviewWelcomePage> createState() => _OverviewWelcomePageState();
}

class _OverviewWelcomePageState extends State<OverviewWelcomePage>
    with TickerProviderStateMixin {
  final overviewStore = OverviewStore();

  late final TabController tabController;
  late final PageController pageController;

  // Controle para animação das imagens.
  late final List<AnimationController> imageControllers;

  @override
  initState() {
    super.initState();

    setTabController();
    setPageController();
    setImageControllers();

    pageController.addListener(handlePageScrolling);
  }

  @override
  dispose() {
    tabController.dispose();
    pageController.dispose();

    for (final AnimationController controller in imageControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void setTabController() {
    tabController = TabController(
      length: overviewStore.overviewItems.length,
      vsync: this,
    );
  }

  void setPageController() {
    pageController = PageController(
      initialPage: 0,
    );
  }

  void setImageControllers() {
    imageControllers = List.generate(
      overviewStore.overviewItems.length,
      (int index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
      ),
    );
  }

  bool _isScrollingBack(double pageOffset, int currentPage) {
    return pageOffset < 0.5 &&
        !overviewStore.isScrolling &&
        currentPage < overviewStore.index;
  }

  bool _isScrollingForward(double pageOffset, int currentPage) {
    return pageOffset > 0.5 &&
        !overviewStore.isScrolling &&
        overviewStore.index == currentPage;
  }

  void handlePageScrolling() {
    final int currentPage = pageController.page!.toInt();
    final double pageOffset = pageController.page! - currentPage;

    if (_isScrollingBack(pageOffset, currentPage)) {
      overviewStore.isScrolling = true;
      handleImageAnimation();
    }

    if (_isScrollingForward(pageOffset, currentPage)) {
      overviewStore.isScrolling = true;
      handleImageAnimation();
    }

    // Quando a animação da rolagem for concluída, atualiza o estado.
    if (pageOffset == 0.0) {
      overviewStore.index = currentPage;
      overviewStore.isScrolling = false;
    }
  }

  void handleImageAnimation() {
    for (var index = 0; index < imageControllers.length; index++) {
      if (index != pageController.page?.round()) {
        imageControllers[index].reset();
        continue;
      }

      imageControllers[index].forward();
    }
  }

  Widget buildPage(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String description,
    required int index,
  }) {
    final TranslateManagerStore translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 24.0,
            children: [
              SizedBox(
                width: double.infinity,
                child: ScaleTransition(
                  scale: OverviewContainer.of(context)
                      .imageControllers
                      .elementAt(index)
                      .drive(
                        CurveTween(
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                  child: SvgPicture(
                    SvgAssetLoader(
                      imagePath,
                      colorMapper: ColorizeVector(
                        targetColors: [
                          Color(0xff6c63ff),
                        ],
                        replacementColors: [
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.height / 3,
                  ),
                ),
              ),
              Wrap(
                runSpacing: 16.0,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      translateManagerStore.fetchLocalizedStrings(title),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      translateManagerStore.fetchLocalizedStrings(
                        description,
                        replacements: getOverviewReplacements(description),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getOverviewItems(
      BuildContext context, List<OverviewItemModel> overviewItems) {
    return List.generate(
      overviewItems.length,
      (int index) => buildPage(
        context,
        imagePath: overviewItems[index].imagePath,
        title: overviewItems[index].title,
        description: overviewItems[index].description,
        index: index,
      ),
    );
  }

  // Retorna as strings que devem ser substituidas na descrição de cada item.
  List<String> getOverviewReplacements(String description) {
    switch (description) {
      case "overview.get_started.description":
        return [
          AppConstant.appName,
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inicialização da animação.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleImageAnimation();
    });

    return OverviewContainer(
      overviewStore: overviewStore,
      tabController: tabController,
      pageController: pageController,
      imageControllers: imageControllers,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: ButtonBackWidget(),
          actions: [
            ButtonSkipWidget(),
          ],
        ),
        floatingActionButton: ButtonNextWidget(),
        body: Column(
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
                child: AnimatedBuilder(
                  animation: overviewStore,
                  builder: (BuildContext context, _) {
                    return PageView(
                      clipBehavior: Clip.none,
                      controller: pageController,
                      physics: overviewStore.isScrolling
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      children: getOverviewItems(
                          context, overviewStore.overviewItems),
                    );
                  },
                ),
              ),
            ),
            PageIndicatorWidget(),
          ],
        ),
      ),
    );
  }
}
