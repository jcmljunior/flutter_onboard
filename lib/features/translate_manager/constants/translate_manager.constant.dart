import 'dart:ui' show Locale;

typedef AvailableLocaleItem = Locale;
typedef AvailableLocalesList = List<AvailableLocaleItem>;

typedef LocalizedStringsItem = Map<String, String>;
typedef LocalizedStringsMap = Map<String, LocalizedStringsItem>;

typedef IsFullyTranslatedItem = bool;
typedef IsFullyTranslatedMap = Map<AvailableLocaleItem, IsFullyTranslatedItem>;

class TranslateManagerConstant {
  static const String defaultPathForLocales = 'resources/locales';
  static const AvailableLocaleItem defaultLocale =
      AvailableLocaleItem.fromSubtags(
    languageCode: 'pt',
    countryCode: 'BR',
  );
  static const List<AvailableLocaleItem> availableLocales = [
    AvailableLocaleItem.fromSubtags(
      languageCode: 'pt',
      countryCode: 'BR',
    ),
    AvailableLocaleItem.fromSubtags(
      languageCode: 'en',
      countryCode: 'US',
    ),
    AvailableLocaleItem.fromSubtags(
      languageCode: 'es',
      countryCode: 'ES',
    ),
  ];
  static const LocalizedStringsMap defaultLocalizedStrings = {};
  static const IsFullyTranslatedMap defaultIsFullyTranslated = {};
  static const bool defaultIsLoading = false;
}
