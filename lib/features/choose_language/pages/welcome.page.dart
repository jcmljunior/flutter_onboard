import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/constants/app.constant.dart';
import '../../../app/containers/app.container.dart';
import '../../../app/stores/app.store.dart';
import '../../../core/dialog/stores/dialog.store.dart';
import '../../colorize_vectors/colorize_vector.dart';
import '../../translate_manager/constants/translate_manager.constant.dart';
import '../../translate_manager/containers/translate_manager.container.dart';
import '../../translate_manager/stores/translate_manager.store.dart';
import '../containers/choose_language.container.dart';
import '../widgets/floating_action_button.widget.dart';

@immutable
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final DialogStore dialogStore = DialogStore();

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    platformDispatcherLocaleHandler(context);
  }

  Widget displayLanguageChoices(BuildContext context) {
    final AvailableLocaleItem platformLanguage =
        View.of(context).platformDispatcher.locale;
    final TranslateManagerStore translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;
    final AvailableLocalesList availableLanguages =
        translateManagerStore.getAvailableLocalesOrderBy(platformLanguage);

    return AnimatedBuilder(
      animation: translateManagerStore,
      builder: (context, child) => Wrap(
        children: List.generate(
          availableLanguages.length,
          (int index) => RadioListTile<Locale>(
            title: Text(
              translateManagerStore.fetchLocalizedStrings(
                  'choose_language.${availableLanguages.elementAt(index)}'),
            ),
            subtitle: availableLanguages.elementAt(index) == platformLanguage
                ? Text(translateManagerStore
                    .fetchLocalizedStrings('choose_language.device_language'))
                : null,
            value: availableLanguages.elementAt(index),
            groupValue: translateManagerStore.currentLocale,
            activeColor: Theme.of(context).colorScheme.primary,
            selected: translateManagerStore.currentLocale ==
                availableLanguages.elementAt(index),
            // Importante: previne que o idioma seja alterado durante a finalização da apresentação do dialogo.
            onChanged: (AvailableLocaleItem? value) => !dialogStore.isShowing
                ? translateManagerStore.updateLocaleHandler(value!)
                : null,
          ),
        ),
      ),
    );
  }

  void platformDispatcherLocaleHandler(BuildContext context) {
    final AppStore appStore = AppContainer.of(context).appStore;
    final TranslateManagerStore translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;
    final AvailableLocaleItem locale =
        View.of(context).platformDispatcher.locale;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!appStore.isInitialized) {
        translateManagerStore.updateLocaleHandler(locale);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChooseLanguageContainer(
      dialogStore: dialogStore,
      child: Scaffold(
        floatingActionButton: const FloatActionButtonWidget(),
        appBar: AppBar(
          forceMaterialTransparency: true,
        ),
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture(
                  SvgAssetLoader(
                    'resources/images/i18n.svg',
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
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Wrap(
                  runSpacing: 16.0,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TranslateManagerContainer.of(context)
                          .translateManagerStore
                          .localizedTextWidget(
                            'choose_language.welcome',
                            replacements: [AppConstant.appName],
                            textTheme:
                                Theme.of(context).textTheme.headlineMedium,
                          ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TranslateManagerContainer.of(context)
                          .translateManagerStore
                          .localizedTextWidget(
                            'choose_language.please_choose_your_language',
                            textTheme: Theme.of(context).textTheme.bodyLarge,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              displayLanguageChoices(context),
            ],
          ),
        ),
      ),
    );
  }
}
