import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/app/containers/theme.container.dart';
import 'package:flutter_onboard/features/app/providers/theme_state.provider.dart';
import 'package:flutter_onboard/features/onboard/pages/onboard.page.dart';
import 'package:flutter_onboard/features/welcome/containers/translate_manager.container.dart';
import 'package:flutter_onboard/features/welcome/pages/welcome.page.dart';

@immutable
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslateManager(
      child: ThemeContainer(
        child: Builder(builder: (BuildContext context) {
          ThemeContainer.of(context)
              .themeStore
              .handlePlatformBrightnessChanged(context);

          return ValueListenableBuilder<ThemeState>(
              valueListenable: ThemeContainer.of(context).themeStore,
              builder:
                  (BuildContext context, ThemeState themeState, Widget? _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Onboard',
                  themeMode: themeState.themeMode,
                  theme: ThemeData(
                    useMaterial3: true,
                    fontFamily: 'Poppins',
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.blueAccent,
                      brightness: ThemeContainer.of(context)
                          .themeStore
                          .getBrightness(context),
                    ),
                  ),
                  initialRoute: '/welcome',
                  routes: {
                    '/welcome': (context) => const Welcome(),
                    '/onboard': (context) => const Onboard(),
                  },
                );
              });
        }),
      ),
    );
  }
}
