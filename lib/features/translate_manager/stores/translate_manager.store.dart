import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_onboard/features/translate_manager/constants/translate_manager.constant.dart';
import 'package:flutter_onboard/features/translate_manager/states/translate_manager.state.dart';

class TranslateManagerStore extends ValueNotifier<TranslateManagerState> {
  TranslateManagerStore() : super(const TranslateManager()) {
    updateLanguageHandler(value.currentLanguage!);
  }

  TranslateManagerState get state => super.value;

  set currentLanguage(String? currentLanguage) {
    value = state.copyWith(
      currentLanguage: currentLanguage,
    );
  }

  String get currentLanguage => state.currentLanguage!;

  set isFullyTranslated(bool? isFullyTranslated) {
    value = state.copyWith(
      isFullyTranslated: isFullyTranslated,
    );
  }

  bool get isFullyTranslated => state.isFullyTranslated!;

  set localizedStrings(Map<String, String>? localizedStrings) {
    value = state.copyWith(
      localizedStrings: localizedStrings,
    );
  }

  Map<String, String> get localizedStrings => state.localizedStrings!;

  List<String> getAvailableLanguagesOrderByLanguage(String language) {
    if (!TranslateManagerConstant.defaultAvailableLanguages
        .contains(language)) {
      return TranslateManagerConstant.defaultAvailableLanguages;
    }

    List<String> languages =
        TranslateManagerConstant.defaultAvailableLanguages.toList();
    languages.remove(language);
    languages.insert(0, language);

    return languages;
  }

  Future<Map<String, String>?> loadLocalizedStrings(String language) async {
    if (!TranslateManagerConstant.defaultAvailableLanguages
        .contains(language)) {
      return null;
    }

    return Map<String, String>.from(
      jsonDecode(
        await rootBundle.loadString(
          'resources/locales/$language.json',
        ),
      ),
    );
  }

  String fetchLocalizedStrings(String key, {List<String>? replacements}) {
    if (value.localizedStrings == null ||
        !value.localizedStrings!.containsKey(key)) {
      return key;
    }

    String message = value.localizedStrings![key]!;

    if (replacements != null) {
      for (int i = 0; i < replacements.length; i++) {
        message = message.replaceFirst(
          RegExp(r'%s'),
          replacements[i],
        );
      }
    }

    return message;
  }

  Widget localizedTextWidget(String key, {List<String>? replacements}) {
    return AnimatedBuilder(
      animation: this,
      builder: (BuildContext context, Widget? _) {
        return Text(
          fetchLocalizedStrings(
            key,
            replacements: replacements,
          ),
        );
      },
    );
  }

  Future<void> updateLanguageHandler(String language) async {
    // Inicalização do idioma padrão.
    await loadLocalizedStrings(TranslateManagerConstant.defaultLanguage)
        .then((Map<String, String>? defaultLocalizedStrings) async {
      await loadLocalizedStrings(language)
          .then((Map<String, String>? newLocalizedStrings) {
        // Atualização do idioma
        currentLanguage = language;

        // Atualização do status de tradução.
        assert(defaultLocalizedStrings != null && newLocalizedStrings != null,
            'defaultLocalizedStrings e newLocalizedStrings não podem ser nulos');
        isFullyTranslated =
            defaultLocalizedStrings!.length == newLocalizedStrings!.length;

        // Atualização das traduções.
        localizedStrings = {
          ...defaultLocalizedStrings,
          ...newLocalizedStrings,
        };
      });
    });
  }
}
