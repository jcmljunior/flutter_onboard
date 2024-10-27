import 'package:flutter/material.dart';

import '../../features/choose_language/pages/welcome.page.dart';
import '../../features/overview/pages/overview_welcome.page.dart';
import '../../features/theme_manager/constants/theme_manager.constant.dart';
import '../../features/theme_manager/containers/theme_manager.container.dart';
import '../../features/theme_manager/stores/theme_manager.store.dart';
import '../../features/translate_manager/containers/translate_manager.container.dart';
import '../../features/translate_manager/repositories/translate_manager.repository_impl.dart';
import '../../features/translate_manager/stores/translate_manager.store.dart';
import '../constants/app.constant.dart';
import '../containers/app.container.dart';
import '../pages/demo1.page.dart';
import '../stores/app.store.dart';

@immutable
class AppWidget extends StatelessWidget {
  final AppStore appStore = AppStore();
  final ThemeManagerStore themeManagerStore = ThemeManagerStore();
  final TranslateManagerStore translateManagerStore =
      TranslateManagerStore(TranslateManagerRepositoryImpl());

  AppWidget({super.key});

  void initializePlatformBrightness(BuildContext context) {
    if (themeManagerStore.themeMode == ThemeMode.system &&
        !appStore.isInitialized) {
      themeManagerStore.brightness =
          View.of(context).platformDispatcher.platformBrightness;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializePlatformBrightness(context);

    return AppContainer(
      appStore: appStore,
      themeManagerStore: themeManagerStore,
      translateManagerStore: translateManagerStore,
      child: ThemeManagerContainer(
        themeManagerStore: themeManagerStore,
        child: TranslateManagerContainer(
          translateManagerStore: translateManagerStore,
          child: AnimatedBuilder(
              animation: Listenable.merge([
                translateManagerStore,
                themeManagerStore,
              ]),
              builder: (BuildContext context, Widget? _) {
                themeManagerStore.handlePlatformBrightnessChanged(context);

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: AppConstant.appName,
                  themeMode: themeManagerStore.themeMode,
                  theme: ThemeData(
                    useMaterial3: ThemeManagerConstant.defaultUseMaterial3,
                    fontFamily: ThemeManagerConstant.defaultFontFamily,
                    floatingActionButtonTheme:
                        ThemeManagerConstant.floatingActionButtonTheme,
                    elevatedButtonTheme:
                        ThemeManagerConstant.elevatedButtonTheme,
                    textButtonTheme: ThemeManagerConstant.textButtonTheme,
                    dialogTheme: ThemeManagerConstant.dialogTheme,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: themeManagerStore.accentColor,
                      brightness: themeManagerStore.brightness,
                    ),
                  ),
                  initialRoute: AppConstant.defaultInitialRoute,
                  routes: {
                    '/': (context) => const WelcomePage(),
                    '/overview': (context) => const OverviewWelcomePage(),
                    '/teste': (context) => const Demo1Page(),
                  },
                );
              }),
        ),
      ),
    );
  }
}
