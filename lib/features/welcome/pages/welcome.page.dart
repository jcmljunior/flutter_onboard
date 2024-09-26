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

  @override
  Widget build(BuildContext context) {
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

                        Wrap(
                          children: List.generate(
                              TranslateManager.of(context)
                                  .translateManagerStore
                                  .availableLanguages
                                  .length, (int index) {
                            return RadioListTile<String>(
                              value: TranslateManager.of(context)
                                  .translateManagerStore
                                  .getPreferredLanguages(context)[index],
                              groupValue: state.currentLanguage!,
                              onChanged: (String? value) {
                                TranslateManager.of(context)
                                    .translateManagerStore
                                    .handleLanguageChange(value!);
                              },
                              title:
                                  Text(TranslateManager.of(context).translate(
                                'onboard/languages/${TranslateManager.of(context).translateManagerStore.availableLanguages[index]}',
                              )),
                              subtitle: View.of(context)
                                      .platformDispatcher
                                      .locale
                                      .toString()
                                      .contains(TranslateManager.of(context)
                                          .translateManagerStore
                                          .availableLanguages[index])
                                  ? Text(TranslateManager.of(context).translate(
                                      'onboard/languages/description',
                                    ))
                                  : null,
                            );
                          }),
                        ),
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
