// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಯುವತಿ';

  @override
  String get letsSetYourLanguage => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಹೊಂದಿಸೋಣ';

  @override
  String get start => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String selectedLanguage(Object language) {
    return 'ಆಯ್ಕೆಯಾಗಿದೆ: @language';
  }

  @override
  String failedToLoad(Object language) {
    return '@language ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';
  }

  @override
  String get home => 'ಮುಖಪುಟ';

  @override
  String get myOrders => 'ನನ್ನ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get results => 'ಫಲಿತಾಂಶಗಳು';

  @override
  String get cart => 'ಕಾರ್ಟ್';
}
