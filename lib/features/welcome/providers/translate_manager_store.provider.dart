import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_onboard/features/welcome/providers/translate_manager_state.provider.dart';

class TranslateManagerStore extends ValueNotifier<TranslateManagerState> {
  TranslateManagerStore() : super(TranslateManagerStateInitial()) {
    // Inicialização do idioma padrão.
    // Necessário caso a informação seja provida por um banco de dados...
    // setLocale('pt_BR');

    // Carregamento dos idiomas disponíveis.
    loadLocalizedStrings(value.currentLanguage!)
        .then((Map<String, String> localizedStrings) {
      setLocalizedStrings(localizedStrings);
    });
  }

  // Importante: os idiomas disponíveis devem estar aqui.
  List<String> get availableLocales => ['en_US', 'pt_BR'];

  String get getLanguageCode => value.currentLanguage!.split('_').first;

  String get getCountryCode => value.currentLanguage!.split('_').last;

  String getLanguageName({String? locale}) {
    if (!availableLocales.contains(locale) && locale != null) {
      throw Exception('Locale not available');
    }

    switch (locale) {
      case 'en_US':
        return 'English';
      case 'pt_BR':
        return 'Portuguese';
      default:
        return 'English';
    }
  }

  Future<Map<String, String>> loadLocalizedStrings(String locale) async {
    try {
      if (!availableLocales.contains(locale)) {
        throw Exception('Locale not available');
      }

      return Map<String, String>.from(
        jsonDecode(
          await rootBundle.loadString('assets/locales/$locale.json'),
        ),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> handleLocaleChange(String? locale) async {
    setLocale(locale).then((_) {
      loadLocalizedStrings(value.currentLanguage!)
          .then((Map<String, String> localizedStrings) {
        setLocalizedStrings(localizedStrings);
      });
    });
  }

  Future setLocale(String? locale) async {
    try {
      if (!availableLocales.contains(locale)) {
        throw Exception('Locale not available');
      }

      value = value.copyWith(
        currentLanguage: locale,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  void setLocalizedStrings(Map<String, String> localizedStrings) {
    value = value.copyWith(
      localizedStrings: localizedStrings,
    );
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
