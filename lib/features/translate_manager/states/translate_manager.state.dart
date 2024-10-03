import 'package:flutter/material.dart' show immutable;
import 'package:flutter_onboard/features/translate_manager/constants/translate_manager.constant.dart';

@immutable
sealed class TranslateManagerState {
  final String? currentLanguage;
  final Map<String, String>? localizedStrings;
  final bool? isFullyTranslated;

  const TranslateManagerState({
    this.currentLanguage,
    this.localizedStrings,
    this.isFullyTranslated,
  }) : assert(currentLanguage != null &&
            localizedStrings != null &&
            isFullyTranslated != null);

  TranslateManagerState copyWith({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? isFullyTranslated,
  });
}

class TranslateManager extends TranslateManagerState {
  const TranslateManager(
      {String? currentLanguage,
      Map<String, String>? localizedStrings,
      bool? isFullyTranslated})
      : super(
            currentLanguage:
                currentLanguage ?? TranslateManagerConstant.defaultLanguage,
            localizedStrings: localizedStrings ??
                TranslateManagerConstant.defaultLocalizedStrings,
            isFullyTranslated: isFullyTranslated ??
                TranslateManagerConstant.defaultIsFullyTranslated);

  @override
  TranslateManagerState copyWith(
      {String? currentLanguage,
      Map<String, String>? localizedStrings,
      bool? isFullyTranslated}) {
    return TranslateManager(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      localizedStrings: localizedStrings ?? this.localizedStrings,
      isFullyTranslated: isFullyTranslated ?? this.isFullyTranslated,
    );
  }
}
