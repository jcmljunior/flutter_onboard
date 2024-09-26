import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/app/constants/app.constant.dart';
import 'package:flutter_onboard/features/welcome/containers/translate_manager.container.dart';
import 'package:flutter_onboard/features/welcome/providers/translate_manager_state.provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  String welcomeTitle(BuildContext context) => TranslateManager.of(context)
      .translate('welcome/title', args: [AppConstant.appName]);

  String welcomeSubtitle(BuildContext context) =>
      TranslateManager.of(context).translate('welcome/subtitle');

  Widget displayLanguageChoices(BuildContext context) {
    final List<String> languages = TranslateManager.of(context)
        .translateManagerStore
        .getPreferredLanguages(context);

    return Wrap(
      children: List.generate(languages.length, (int index) {
        return RadioListTile<String>(
          title: Text(
            TranslateManager.of(context).translate(
              'onboard/languages/${languages[index]}',
            ),
          ),
          subtitle: View.of(context)
                  .platformDispatcher
                  .locale
                  .toString()
                  .contains(TranslateManager.of(context)
                      .translateManagerStore
                      .getPreferredLanguages(context)[index])
              ? Text(TranslateManager.of(context).translate(
                  'onboard/languages/description',
                ))
              : null,
          value: languages[index],
          groupValue: TranslateManager.of(context)
              .translateManagerStore
              .value
              .currentLanguage,
          onChanged: (String? value) {
            TranslateManager.of(context)
                .translateManagerStore
                .handleLanguageChange(value!);
          },
        );
      }),
    );
  }

  void handlePlatformDispatchLanguage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TranslateManager.of(context).translateManagerStore.handleLanguageChange(
          TranslateManager.of(context)
              .translateManagerStore
              .getPreferredLanguages(context)
              .first);
    });
  }

  @override
  Widget build(BuildContext context) {
    handlePlatformDispatchLanguage(context);

    return ValueListenableBuilder<TranslateManagerState>(
        valueListenable: TranslateManager.of(context).translateManagerStore,
        builder:
            (BuildContext context, TranslateManagerState state, Widget? _) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            Icons.language,
                            size: 300.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        // Animação do titulo.
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 450),
                          switchInCurve: Curves.linear,
                          switchOutCurve: Curves.fastOutSlowIn,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            welcomeTitle(context),
                            key: ValueKey<String>(
                              welcomeTitle(context),
                            ),
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),

                        const SizedBox(
                          height: 24.0,
                        ),

                        // Animação do subtitulo.
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 450),
                          switchInCurve: Curves.linear,
                          switchOutCurve: Curves.fastOutSlowIn,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            welcomeSubtitle(context),
                            key: ValueKey<String>(
                              welcomeSubtitle(context),
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),

                        // Apresentação dos idiomas.
                        const SizedBox(
                          height: 24.0,
                        ),

                        displayLanguageChoices(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 1.0,
              shape: const CircleBorder(),
              onPressed: () {
                if (!state.hasCompleteTranslation!) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          TranslateManager.of(context).translate(
                            'onboard/show_language_incomplete_dialog/title',
                          ),
                        ),
                        content: Text(
                          TranslateManager.of(context).translate(
                              'onboard/show_language_incomplete_dialog/content',
                              args: [
                                state.currentLanguage!,
                              ]),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              TranslateManager.of(context).translate(
                                'onboard/show_language_incomplete_dialog/actions/ok',
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed('/onboard');
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              TranslateManager.of(context).translate(
                                'onboard/show_language_incomplete_dialog/actions/cancel',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  return;
                }

                Navigator.of(context).pushReplacementNamed('/onboard');
              },
              child: const Icon(Icons.chevron_right),
            ),
          );
        });
  }
}
