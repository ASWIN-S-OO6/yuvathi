import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translation_service.dart';

class LocaleProvider with ChangeNotifier {
  String _selectedLanguageName = 'English';

  String get selectedLanguageName => _selectedLanguageName;

  LocaleProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    if (TranslationService.supportedLanguages.containsKey(savedLanguage)) {
      _selectedLanguageName = savedLanguage;
      notifyListeners();
    }
  }

  Future<void> setLocale(String languageName) async {
    if (TranslationService.supportedLanguages.containsKey(languageName)) {
      _selectedLanguageName = languageName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', languageName);
      // Ensure the language model is downloaded
      await TranslationService.ensureModelDownloaded(
          TranslationService.supportedLanguages[languageName]!);
      notifyListeners();
    }
  }
}