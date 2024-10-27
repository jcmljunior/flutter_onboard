import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

import 'package:flutter/services.dart' show rootBundle;

import '../constants/translate_manager.constant.dart';

import 'translate_manager.repository.dart';

class TranslateManagerRepositoryImpl implements TranslateManagerRepository {
  @override
  Future<LocalizedStringsMap> loadLocalizedStrings(AvailableLocaleItem locale,
      {LocalizedStringsMap fallback =
          TranslateManagerConstant.defaultLocalizedStrings}) async {
    try {
      final Map<String, dynamic> response = jsonDecode(
        await rootBundle.loadString(
          '${TranslateManagerConstant.defaultPathForLocales}/${locale.toString()}.json',
        ),
      );

      return {
        locale.toString(): Map<String, String>.from(response),
      };
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);

      return fallback;
    }
  }
}
