import 'package:flutter/material.dart';

import '../../../app/extensions/value_notifier.extension.dart';
import '../constants/translate_manager.constant.dart';
import '../repositories/translate_manager.repository.dart';
import '../states/translate_manager.state.dart';

class TranslateManagerStore extends ValueNotifier<TranslateManagerState> {
  final TranslateManagerRepository _repository;

  TranslateManagerStore(this._repository) : super(const TranslateManager()) {
    updateLocaleHandler(currentLocale, force: true);
  }

  set currentLocale(AvailableLocaleItem newLocale) {
    if (currentLocale == newLocale) return;

    state = state.copyWith(
      currentLocale: newLocale,
    );
  }

  AvailableLocaleItem get currentLocale => state.currentLocale!;

  set localizedStrings(LocalizedStringsMap newLocalizedStrings) {
    if (localizedStrings == newLocalizedStrings) return;

    state = state.copyWith(
      localizedStrings: {
        ...newLocalizedStrings,
        ...localizedStrings,
      },
    );
  }

  LocalizedStringsMap get localizedStrings => state.localizedStrings!;

  set isFullyTranslated(IsFullyTranslatedMap newIsFullyTranslated) {
    if (isFullyTranslated == newIsFullyTranslated) return;

    state = state.copyWith(
      isFullyTranslated: newIsFullyTranslated,
    );
  }

  IsFullyTranslatedMap get isFullyTranslated => state.isFullyTranslated!;

  set isLoading(bool newIsLoading) {
    if (isLoading == newIsLoading) return;

    state = state.copyWith(
      isLoading: newIsLoading,
    );
  }

  bool get isLoading => state.isLoading!;

  set error(String newError) {
    if (error == newError) return;

    state = state.copyWith(
      error: newError,
    );
  }

  String get error => state.error!;

  AvailableLocaleItem setCurrentLocale(AvailableLocaleItem newLocale) =>
      currentLocale = newLocale;

  Future<LocalizedStringsMap> setLocalizedStrings(
          LocalizedStringsMap newLocalizedStrings) async =>
      localizedStrings = newLocalizedStrings;

  Future<IsFullyTranslatedMap> setIsFullyTranslated(
          IsFullyTranslatedMap newIsFullyTranslated) async =>
      isFullyTranslated = newIsFullyTranslated;

  Future<bool> setIsLoading(bool newIsLoading) async =>
      isLoading = newIsLoading;

  Future<LocalizedStringsMap> loadLocalizedStringsHandler(
      AvailableLocaleItem locale) async {
    // Retorna o pacote de idioma presente no cache.
    if (localizedStrings.containsKey(locale.toString())) {
      return localizedStrings;
    }

    return await _repository.loadLocalizedStrings(locale);
  }

  Future<bool> localeExistsHandler(AvailableLocaleItem locale) async {
    return localizedStrings
        .containsKey(TranslateManagerConstant.defaultLocale.toString());
  }

  // Função responsável por lidar com a atualização do pacote de idioma.
  // Use force como verdadeiro para a primeira inicialização do carregamento do pacote de idioma padrão.
  void updateLocaleHandler(AvailableLocaleItem newLocale,
      {bool force = false}) async {
    if (newLocale == currentLocale && !force) return;

    setIsLoading(true);

    try {
      final LocalizedStringsMap newLocalizedStrings =
          await loadLocalizedStringsHandler(newLocale);

      setIsFullyTranslated({
        ...isFullyTranslated,
        newLocale: localizedStrings.containsKey(newLocale.toString())
            ? localizedStrings[
                        TranslateManagerConstant.defaultLocale.toString()]!
                    .length ==
                newLocalizedStrings[newLocale.toString()]!.length
            : force,
      });

      setLocalizedStrings({
        ...newLocalizedStrings,
      });
    } finally {
      setCurrentLocale(newLocale);
      setIsLoading(false);
    }
  }

  // Função responsável por remover os pacotes de idioma que  não serão utilizados.
  void cleanUnusedLocalizedStringsHandler() {
    localizedStrings.removeWhere((String key, _) =>
        key != currentLocale.toString() &&
        key != TranslateManagerConstant.defaultLocale.toString());
  }

  String fetchLocalizedStrings(String key, {List<String>? replacements}) {
    String message = localizedStrings[currentLocale.toString()]?[key] ??
        localizedStrings[TranslateManagerConstant.defaultLocale.toString()]
            ?[key] ??
        key;

    if (replacements != null) {
      for (final String word in replacements) {
        message = message.replaceFirst(
          RegExp(r'%s'),
          word,
        );
      }
    }

    return message;
  }

  Widget localizedTextWidget(String key,
      {List<String>? replacements, TextStyle? textTheme}) {
    return AnimatedBuilder(
      animation: this,
      builder: (BuildContext context, Widget? _) => Text(
        fetchLocalizedStrings(
          key,
          replacements: replacements,
        ),
        style: textTheme,
      ),
    );
  }

  List<AvailableLocaleItem> getAvailableLocalesOrderBy(
      AvailableLocaleItem locale) {
    final List<AvailableLocaleItem> availableLocales =
        TranslateManagerConstant.availableLocales.toList();

    if (!availableLocales.contains(locale)) {
      return availableLocales;
    }

    availableLocales.removeWhere(
        (AvailableLocaleItem currentLocale) => currentLocale == locale);
    availableLocales.insert(0, locale);

    return availableLocales;
  }
}
