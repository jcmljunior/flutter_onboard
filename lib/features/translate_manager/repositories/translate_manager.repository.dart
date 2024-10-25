import 'package:flutter/material.dart' show immutable;

import '../constants/translate_manager.constant.dart';

@immutable
abstract class TranslateManagerRepository {
  Future<LocalizedStringsMap> loadLocalizedStrings(AvailableLocaleItem locale,
      {LocalizedStringsMap fallback =
          TranslateManagerConstant.defaultLocalizedStrings});
}
