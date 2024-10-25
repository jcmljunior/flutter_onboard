import 'package:flutter/material.dart' show immutable;

import '../constants/translate_manager.constant.dart';

@immutable
sealed class TranslateManagerState {
  final AvailableLocaleItem? currentLocale;
  final LocalizedStringsMap? localizedStrings;
  final IsFullyTranslatedMap? isFullyTranslated;
  final bool? isLoading;
  final String? error;

  const TranslateManagerState({
    this.currentLocale,
    this.localizedStrings,
    this.isFullyTranslated,
    this.isLoading,
    this.error,
  }) : assert(currentLocale != null &&
            localizedStrings != null &&
            isFullyTranslated != null &&
            isLoading != null &&
            error != null);

  TranslateManagerState copyWith({
    AvailableLocaleItem? currentLocale,
    LocalizedStringsMap? localizedStrings,
    IsFullyTranslatedMap? isFullyTranslated,
    bool? isLoading,
    String? error,
  });
}

class TranslateManager extends TranslateManagerState {
  const TranslateManager({
    AvailableLocaleItem? currentLocale,
    LocalizedStringsMap? localizedStrings,
    IsFullyTranslatedMap? isFullyTranslated,
    bool? isLoading,
    String? error,
  }) : super(
          currentLocale:
              currentLocale ?? TranslateManagerConstant.defaultLocale,
          localizedStrings: localizedStrings ??
              TranslateManagerConstant.defaultLocalizedStrings,
          isFullyTranslated: isFullyTranslated ??
              TranslateManagerConstant.defaultIsFullyTranslated,
          isLoading: isLoading ?? TranslateManagerConstant.defaultIsLoading,
          error: error ?? '',
        );

  @override
  TranslateManagerState copyWith({
    AvailableLocaleItem? currentLocale,
    LocalizedStringsMap? localizedStrings,
    IsFullyTranslatedMap? isFullyTranslated,
    bool? isLoading,
    String? error,
  }) =>
      TranslateManager(
        currentLocale: currentLocale ?? this.currentLocale,
        localizedStrings: localizedStrings ?? this.localizedStrings,
        isFullyTranslated: isFullyTranslated ?? this.isFullyTranslated,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
