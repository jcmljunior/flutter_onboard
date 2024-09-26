import 'package:flutter/material.dart';

@immutable
sealed class TranslateManagerState {
  final String? currentLanguage;
  final Map<String, String>? localizedStrings;
  final bool? hasCompleteTranslation;

  const TranslateManagerState({
    this.currentLanguage,
    this.localizedStrings,
    this.hasCompleteTranslation,
  });

  TranslateManagerState copyWith({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? hasCompleteTranslation,
  });
}

class TranslateManagerStateInitial extends TranslateManagerState {
  TranslateManagerStateInitial({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? hasCompletedTranslation,
  }) : super(
          currentLanguage: currentLanguage ?? 'en_US',
          localizedStrings: localizedStrings ?? {},
          hasCompleteTranslation: hasCompletedTranslation ?? false,
        );

  @override
  TranslateManagerState copyWith({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
    bool? hasCompleteTranslation,
  }) {
    return TranslateManagerStateInitial(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      localizedStrings: localizedStrings ?? this.localizedStrings,
      hasCompletedTranslation: hasCompleteTranslation,
    );
  }
}
