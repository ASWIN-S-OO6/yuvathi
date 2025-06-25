import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  static final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();

  // Cache for translated texts
  static final Map<String, Map<String, String>> _translationCache = {};

  static const Map<String, String> supportedLanguages = {
    'English': 'en',
    'Tamil': 'ta',
    'Malayalam': 'ml',
    'Hindi': 'hi',
    'Telugu': 'te',
    'Kannada': 'kn',
  };

  static TranslateLanguage? _getTranslateLanguage(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return TranslateLanguage.english;
      case 'ta':
        return TranslateLanguage.tamil;
      case 'ml':
        return TranslateLanguage.malay;
      case 'hi':
        return TranslateLanguage.hindi;
      case 'te':
        return TranslateLanguage.telugu;
      case 'kn':
        return TranslateLanguage.kannada;
      default:
        return null;
    }
  }

  static String _getCacheKey(String text, String targetLanguageCode) {
    return '$text:$targetLanguageCode';
  }

  static Future<bool> ensureModelDownloaded(String languageCode) async {
    try {
      final translateLanguage = _getTranslateLanguage(languageCode);
      if (translateLanguage == null) return false;

      if (await _modelManager.isModelDownloaded(translateLanguage.bcpCode)) {
        return true;
      }
      return await _modelManager.downloadModel(translateLanguage.bcpCode);
    } catch (e) {
      print('Error downloading model: $e');
      return false;
    }
  }

  static Future<String> translate(
    String text,
    String targetLanguageCode,
  ) async {
    // If target language is English or empty, return original text
    if (targetLanguageCode == 'en' || targetLanguageCode.isEmpty) {
      return text;
    }

    try {
      // Check cache first
      final cacheKey = _getCacheKey(text, targetLanguageCode);
      if (_translationCache.containsKey(targetLanguageCode) &&
          _translationCache[targetLanguageCode]!.containsKey(text)) {
        return _translationCache[targetLanguageCode]![text]!;
      }

      final targetLanguage = _getTranslateLanguage(targetLanguageCode);
      if (targetLanguage == null) {
        return text; // Return original text if language not supported
      }

      // Ensure the model is downloaded
      if (!await ensureModelDownloaded(targetLanguageCode)) {
        return text; // Return original text if model download fails
      }

      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: targetLanguage,
      );

      final translatedText = await translator.translateText(text);
      translator.close();

      // Cache the result
      _translationCache[targetLanguageCode] ??= {};
      _translationCache[targetLanguageCode]![text] = translatedText;

      return translatedText;
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text on error
    }
  }

  static void clearCache() {
    _translationCache.clear();
  }
}
