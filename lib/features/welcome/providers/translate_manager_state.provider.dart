import 'package:flutter/material.dart';

@immutable
sealed class TranslateManagerState {
  final String? currentLanguage;
  final Map<String, String>? localizedStrings;

  const TranslateManagerState({
    this.currentLanguage,
    this.localizedStrings,
  });

  TranslateManagerState copyWith({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
  });
}

class TranslateManagerStateInitial extends TranslateManagerState {
  TranslateManagerStateInitial({
    String? currentLanguage,
    Map<String, String>? localizedStrings,
  }) : super(
          currentLanguage: currentLanguage ?? 'en_US',
          localizedStrings: localizedStrings ?? {},
        );

  @override
  TranslateManagerState copyWith(
      {String? currentLanguage, Map<String, String>? localizedStrings}) {
    return TranslateManagerStateInitial(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      localizedStrings: localizedStrings ?? this.localizedStrings,
    );
  }
}
