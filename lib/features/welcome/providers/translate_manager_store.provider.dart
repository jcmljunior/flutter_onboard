import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_onboard/features/welcome/providers/translate_manager_state.provider.dart';

class TranslateManagerStore extends ValueNotifier<TranslateManagerState> {
  TranslateManagerStore() : super(TranslateManagerStateInitial()) {
    handleInitialLanguage();
  }

  List<String> get availableLanguages => ['en_US', 'pt_BR', 'es_ES'];

  String get defaultLanguage => 'pt_BR';

  String get languageCode => value.currentLanguage!.split('_').first;

  String get countryCode => value.currentLanguage!.split('_').last;

  Future<void> setLanguage(String newLanguage) async {
    if (!availableLanguages.contains(newLanguage)) {
      return;
    }

    value = value.copyWith(
      currentLanguage: newLanguage,
    );
  }

  Future<void> setLocalizedStrings(
      Map<String, String> newLocalizedStrings) async {
    await loadLocalizedStrings(defaultLanguage).then((localizedStrings) {
      value = value.copyWith(
        localizedStrings: localizedStrings!.map((String key, String value) {
          return MapEntry(
            key,
            newLocalizedStrings[key] ?? value,
          );
        }),
      );
    });
  }

  Future<Map<String, String>?> loadLocalizedStrings(String language) async {
    if (!availableLanguages.contains(language)) {
      return null;
    }

    return Map<String, String>.from(
      jsonDecode(
        await rootBundle.loadString(
          'assets/locales/$language.json',
        ),
      ),
    );
  }

  Future<void> handleInitialLanguage() async {
    await loadLocalizedStrings(value.currentLanguage!).then((localizedStrings) {
      setLocalizedStrings(localizedStrings!);
    });
  }

  Future<void> handleLanguageChange(String newLanguage) async {
    await setLanguage(newLanguage).then((_) {
      return loadLocalizedStrings(value.currentLanguage!)
          .then((localizedStrings) {
        setLocalizedStrings(localizedStrings!);
      });
    });
  }

  String translate(String key, {List<String>? args}) {
    assert(
      value.localizedStrings != null,
      'Localized Strings not initialized.',
    );

    if (!value.localizedStrings!.containsKey(key)) {
      return key;
    }

    String message = value.localizedStrings![key]!;

    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        message = message.replaceFirst(RegExp(r'%s'), args[i]);
      }
    }

    return message;
  }
}
