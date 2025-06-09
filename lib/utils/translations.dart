import 'dart:convert';
import 'package:flutter/services.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  Map<String, dynamic> _localizedStrings = {};

  factory TranslationService() {
    return _instance;
  }

  TranslationService._internal();

  Future<void> loadLanguage(String languageCode) async {
    // Load the JSON file from the i18n folder
    String jsonString = await rootBundle.loadString('i18n/$languageCode.json');
    _localizedStrings = json.decode(jsonString);
  }

  String translate(String key) {
    return _localizedStrings[key] ?? '** $key not found';
  }
}
