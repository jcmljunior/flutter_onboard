import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/language_picker/pages/language_picker.page.dart';
import 'package:flutter_onboard/features/overview/pages/overview.page.dart';
import 'package:flutter_onboard/features/theme_manager/containers/theme_manager.container.dart';
import 'package:flutter_onboard/features/theme_manager/states/theme_manager.state.dart';
import 'package:flutter_onboard/features/theme_manager/stores/theme_manager.store.dart';
import 'package:flutter_onboard/features/translate_manager/containers/translate_manager.container.dart';
import 'package:flutter_onboard/features/translate_manager/stores/translate_manager.store.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslateManagerContainer(
      translateManagerStore: TranslateManagerStore(),
      child: ThemeManagerContainer(
        themeManagerStore: ThemeManagerStore(),
        child: Builder(builder: (BuildContext context) {
          ThemeManagerContainer.of(context)
              .themeManagerStore
              .handlePlatformBrightnessChanged(context);

          return ValueListenableBuilder(
            valueListenable:
                ThemeManagerContainer.of(context).themeManagerStore,
            builder:
                (BuildContext context, ThemeManagerState state, Widget? _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Onboard',
                themeMode: state.themeMode,
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: state.accentColor!,
                    brightness: ThemeManagerContainer.of(context)
                        .themeManagerStore
                        .getBrightness(context),
                  ),
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => const LanguagePickerPage(),
                  '/overview': (context) => const OverviewPage(),
                },
              );
            },
          );
        }),
      ),
    );
  }
}
