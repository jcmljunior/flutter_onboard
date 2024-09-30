import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onboard/features/translate/constants/translate.constant.dart';
import 'package:flutter_onboard/features/translate/providers/translate_manager_state.provider.dart';

class TranslateManagerStoreProvider
    extends ValueNotifier<TranslateManagerStateProvider> {
  TranslateManagerStoreProvider() : super(const TranslateManagerState()) {
    updateLanguageHandler(value.currentLanguage!);
  }

  Future<void> setCurrentLanguage(String? currentLanguage) async {
    value = value.copyWith(
      currentLanguage: currentLanguage,
    );
  }

  Future<void> setLocalizedStrings(
      Map<String, String>? localizedStrings) async {
    value = value.copyWith(
      localizedStrings: localizedStrings,
    );
  }

  Future<void> setHasCompletedTranslation(bool hasCompletedTranslation) async {
    value = value.copyWith(
      hasCompletedTranslation: hasCompletedTranslation,
    );
  }

  List<String> getAvailableLanguagesOrderByLanguage(String language) {
    if (!TranslateConstant.availableLanguages.contains(language)) {
      return TranslateConstant.availableLanguages;
    }

    List<String> languages = TranslateConstant.availableLanguages.toList();
    languages.remove(language);
    languages.insert(0, language);

    return languages;
  }

  Future<Map<String, String>?> loadLocalizedStrings(String language) async {
    if (!TranslateConstant.availableLanguages.contains(language)) {
      return null;
    }

    return Map<String, String>.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/i18n/$language.json',
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
        message = message.replaceFirst(RegExp(r'%s'), replacements[i]);
      }
    }

    return message;
  }

  Future<void> updateLanguageHandler(String language) async {
    // Inicialização do arquivo de idiomas padrão.
    await loadLocalizedStrings(TranslateConstant.defaultLanguage)
        .then((Map<String, String>? localizedStrings) async {
      await setCurrentLanguage(language).then((_) async {
        // Inicialização do arquivo de idiomas solicitado.
        await loadLocalizedStrings(language)
            .then((Map<String, String>? newLocalizedStrings) async {
          setHasCompletedTranslation(
              newLocalizedStrings!.length == localizedStrings!.length);

          setLocalizedStrings({
            ...localizedStrings,
            ...newLocalizedStrings,
          });
        });
      });
    });
  }
}
