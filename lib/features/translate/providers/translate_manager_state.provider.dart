import 'package:flutter/material.dart' show immutable;
import 'package:flutter_onboard/features/translate/constants/translate.constant.dart';

@immutable
sealed class TranslateManagerStateProvider {
  final bool? isLoading;
  final String? currentLanguage;
  final Map<String, String>? localizedStrings;
  final bool? hasCompletedTranslation;

  const TranslateManagerStateProvider({
    this.isLoading,
    this.currentLanguage,
    this.localizedStrings,
    this.hasCompletedTranslation,
  });

  TranslateManagerState copyWith({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? hasCompletedTranslation,
  });
}

class TranslateManagerState extends TranslateManagerStateProvider {
  const TranslateManagerState({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? hasCompletedTranslation,
  }) : super(
          isLoading: false,
          currentLanguage: currentLanguage ?? TranslateConstant.defaultLanguage,
          localizedStrings: localizedStrings ?? const {},
          hasCompletedTranslation: hasCompletedTranslation ?? true,
        );

  @override
  TranslateManagerState copyWith({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? hasCompletedTranslation,
  }) {
    return TranslateManagerState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      localizedStrings: localizedStrings ?? this.localizedStrings,
      hasCompletedTranslation:
          hasCompletedTranslation ?? this.hasCompletedTranslation,
    );
  }
}
