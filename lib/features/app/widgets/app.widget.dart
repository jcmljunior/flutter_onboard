import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/language_picker/pages/language_picker.page.dart';
import 'package:flutter_onboard/features/overview/pages/overview.page.dart';
import 'package:flutter_onboard/features/theme/containers/theme.container.dart';
import 'package:flutter_onboard/features/theme/providers/theme_state.provider.dart';
import 'package:flutter_onboard/features/translate/containers/translate.container.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslateContainer(
      child: ThemeContainer(
        child: Builder(builder: (BuildContext context) {
          ThemeContainer.of(context)
              .themeStore
              .handlePlatformBrightnessChanged(context);

          return ValueListenableBuilder(
            valueListenable: ThemeContainer.of(context).themeStore,
            builder:
                (BuildContext context, ThemeStateProvider state, Widget? _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Onboard',
                themeMode: state.themeMode,
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: state.accentColor!,
                    brightness: ThemeContainer.of(context)
                        .themeStore
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
