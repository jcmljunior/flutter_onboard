import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/app/constants/app.constant.dart';
import 'package:flutter_onboard/features/language_picker/constants/language_picker.constant.dart';
import 'package:flutter_onboard/features/language_picker/containers/language_picker.container.dart';
import 'package:flutter_onboard/features/language_picker/widgets/language_picker_button.widget.dart';
import 'package:flutter_onboard/features/translate/constants/translate.constant.dart';
import 'package:flutter_onboard/features/translate/containers/translate.container.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return AnimatedBuilder(
      animation: TranslateContainer.of(context).translateManagerStoreProvider,
      builder: (BuildContext context, Widget? child) {
        List<String> languages = TranslateContainer.of(context)
            .translateManagerStoreProvider
            .getAvailableLanguagesOrderByLanguage(
                View.of(context).platformDispatcher.locale.toString());
        return Wrap(
          children: List.generate(
            languages.length,
            (int index) {
              return RadioListTile<String>(
                title: Text(
                  TranslateContainer.of(context).fetchLocalizedStrings(
                    'language_picker/i18n/${languages[index]}',
                  ),
                ),
                subtitle: languages[index] ==
                        View.of(context).platformDispatcher.locale.toString()
                    ? Text(
                        TranslateContainer.of(context).fetchLocalizedStrings(
                          'language_picker/i18n/description',
                        ),
                      )
                    : null,
                value: languages[index],
                groupValue: TranslateContainer.of(context)
                    .translateManagerStoreProvider
                    .value
                    .currentLanguage,
                onChanged: (String? value) {
                  TranslateContainer.of(context)
                      .translateManagerStoreProvider
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
                              '${TranslateConstant.defaultAssetPath}i18n.svg',
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
                    AnimatedBuilder(
                      animation: TranslateContainer.of(context)
                          .translateManagerStoreProvider,
                      builder: (BuildContext context, Widget? child) {
                        return Wrap(
                          runSpacing: 16.0,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                TranslateContainer.of(context)
                                    .fetchLocalizedStrings(
                                  'language_picker/title',
                                  replacements: [
                                    AppConstant.appName,
                                  ],
                                ),
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                TranslateContainer.of(context)
                                    .fetchLocalizedStrings(
                                  'language_picker/description',
                                ),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        );
                      },
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
