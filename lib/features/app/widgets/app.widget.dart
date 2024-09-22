import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/app/containers/theme.container.dart';
import 'package:flutter_onboard/features/app/pages/teste.page.dart';
import 'package:flutter_onboard/features/app/providers/theme_state.provider.dart';
import 'package:flutter_onboard/features/onboard/pages/onboard.page.dart';

@immutable
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
      child: Builder(builder: (BuildContext context) {
        ThemeContainer.of(context)
            .themeStore
            .handlePlatformBrightnessChanged(context);

        return ValueListenableBuilder<ThemeState>(
            valueListenable: ThemeContainer.of(context).themeStore,
            builder: (BuildContext context, ThemeState themeState, Widget? _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Onboard',
                themeMode: themeState.themeMode,
                theme: ThemeData(
                  useMaterial3: true,
                  fontFamily: 'Poppins',
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: ThemeContainer.of(context)
                        .themeStore
                        .getBrightness(context),
                  ),
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => const Onboard(),
                  '/teste': (context) => const TestePage(),
                },
              );
            });
      }),
    );
  }
}
