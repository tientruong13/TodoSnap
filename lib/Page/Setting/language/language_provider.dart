import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Language {
  final String code;
  final String name;

  Language({required this.code, required this.name});
}

class LanguageProvider with ChangeNotifier {
  static const String _languageBox = 'languageBox';
  static const String _languageKey = 'appLanguage';
  String _appLanguageCode = 'en';

  LanguageProvider() {
    _initAppLanguageCode();
  }

  List<Language> get languages {
    List<Language> _languages = [
      Language(code: 'en', name: 'English'),
      Language(code: 'es', name: 'Spanish'),
      Language(code: 'vi', name: 'Vietnamese'),
      Language(code: 'fr', name: 'French'),
      Language(code: 'de', name: 'German'),
      Language(code: 'zh', name: 'Chinese'),
      Language(code: 'hi', name: 'India'),
      Language(code: 'ru', name: 'Russian'),
      Language(code: 'pt', name: 'Portugal'),
      Language(code: 'ja', name: 'Japan'),
      Language(code: 'ko', name: 'Korean'),
    ];

    _languages.sort((a, b) => a.name.compareTo(b.name));

    return _languages;
  }

  String get currentLanguageCode => _appLanguageCode;

  void changeLanguage(BuildContext context, String languageCode) async {
    if (languageCode.isNotEmpty) {
      _appLanguageCode = languageCode;
      EasyLocalization.of(context)!.setLocale(Locale(languageCode));
      notifyListeners();
      await _saveLanguageToHive(languageCode);
      await _initAppLanguageCode();
    }
  }

  Future<void> _initAppLanguageCode() async {
    final box = await Hive.openBox<String>(_languageBox);
    final storedLanguage = box.get(_languageKey, defaultValue: 'en');
    _appLanguageCode = storedLanguage!;
    notifyListeners();
  }

  Future<void> _saveLanguageToHive(String languageCode) async {
    final box = await Hive.openBox<String>(_languageBox);
    await box.put(_languageKey, languageCode);
  }
}
