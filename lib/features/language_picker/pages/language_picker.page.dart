import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_onboard/features/app/constants/app.constant.dart';
import 'package:flutter_onboard/features/language_picker/constants/language_picker.constant.dart';
import 'package:flutter_onboard/features/language_picker/containers/language_picker.container.dart';
import 'package:flutter_onboard/features/language_picker/widgets/language_picker_button.widget.dart';
import 'package:flutter_onboard/features/translate_manager/containers/translate_manager.container.dart';

@immutable
class Colorize extends ColorMapper {
  final List<Color> targetColors;
  final List<Color> replacementColors;

  const Colorize({
    required this.targetColors,
    required this.replacementColors,
  });

  @override
  Color substitute(
      String? id, String elementName, String attributeName, Color color) {
    for (int i = 0; i < targetColors.length; i++) {
      if (color == targetColors[i]) {
        return replacementColors[i];
      }
    }

    return color;
  }
}

@immutable
class LanguagePickerPage extends StatefulWidget {
  const LanguagePickerPage({super.key});

  @override
  State<LanguagePickerPage> createState() => _LanguagePickerPageState();
}

class _LanguagePickerPageState extends State<LanguagePickerPage>
    with TickerProviderStateMixin {
  late final AnimationController imageController;
  late final AnimationController fabController;
  late final Animation<Offset> fabAnimation;

  @override
  void initState() {
    super.initState();

    setImageController();
    setFabController();
    setFabAnimation();
  }

  @override
  void dispose() {
    imageController.dispose();
    fabController.dispose();

    super.dispose();
  }

  void setImageController() {
    imageController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: LanguagePickerConstant.defaultImageAnimationDuration),
    );
  }

  void imageAnimationHandler() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imageController.forward();
    });
  }

  void setFabController() {
    fabController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: LanguagePickerConstant.defaultFabAnimationDuration),
    );
  }

  void setFabAnimation() {
    fabAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: fabController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void fabAnimationHandler({bool? reverse = false}) {
    if (reverse == true) {
      fabController.reverse();
    } else {
      fabController.forward();
    }
  }

  Widget displayLanguageChoices(BuildContext context) {
    final String platformLanguage =
        View.of(context).platformDispatcher.locale.toString();
    final List<String> availableLanguages =
        TranslateManagerContainer.of(context)
            .translateManagerStore
            .getAvailableLanguagesOrderByLanguage(platformLanguage);

    return AnimatedBuilder(
      animation: TranslateManagerContainer.of(context).translateManagerStore,
      builder: (BuildContext context, Widget? _) {
        return Wrap(
          children: List.generate(
            availableLanguages.length,
            (int index) {
              return RadioListTile<String>(
                value: availableLanguages[index],
                groupValue: TranslateManagerContainer.of(context)
                    .translateManagerStore
                    .currentLanguage,
                title: Text(
                  TranslateManagerContainer.of(context)
                      .translateManagerStore
                      .fetchLocalizedStrings(
                          'language_picker/i18n/${availableLanguages[index]}'),
                ),
                subtitle: availableLanguages[index] != platformLanguage
                    ? null
                    : Text(
                        TranslateManagerContainer.of(context)
                            .translateManagerStore
                            .fetchLocalizedStrings(
                                'language_picker/i18n/description'),
                      ),
                onChanged: (value) {
                  TranslateManagerContainer.of(context)
                      .translateManagerStore
                      .updateLanguageHandler(value!);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    imageAnimationHandler();

    return LanguagePickerContainer(
      imageController: imageController,
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: const LanguagePickerButtonWidget(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  runSpacing: 24.0,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: ScaleTransition(
                          scale: imageController.drive(
                            CurveTween(curve: Curves.easeInOutCubic),
                          ),
                          child: SvgPicture(
                            width: 280.0,
                            SvgAssetLoader(
                              'assets/language_picker/i18n.svg',
                              colorMapper: Colorize(
                                targetColors: const [
                                  Color(0xff6c63ff),
                                ],
                                replacementColors: [
                                  Theme.of(context).colorScheme.primary,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      runSpacing: 16.0,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TranslateManagerContainer.of(context)
                              .translateManagerStore
                              .localizedTextWidget(
                                'language_picker/title',
                                replacements: [
                                  AppConstant.appName,
                                ],
                                textTheme:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TranslateManagerContainer.of(context)
                              .translateManagerStore
                              .localizedTextWidget(
                                'language_picker/description',
                                textTheme:
                                    Theme.of(context).textTheme.bodyLarge,
                              ),
                        ),
                      ],
                    ),
                    displayLanguageChoices(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
