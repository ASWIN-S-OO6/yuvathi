// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'யுவதி';

  @override
  String get letsSetYourLanguage => 'உங்கள் மொழியை அமைப்போம்';

  @override
  String get start => 'தொடங்கு';

  @override
  String selectedLanguage(Object language) {
    return 'தேர்ந்தெடுக்கப்பட்டது: @language';
  }

  @override
  String failedToLoad(Object language) {
    return '@language ஐ ஏற்ற முடியவில்லை';
  }

  @override
  String get home => 'முகப்பு';

  @override
  String get myOrders => 'எனது ஆர்டர்கள்';

  @override
  String get results => 'முடிவுகள்';

  @override
  String get cart => 'கூடை';
}
