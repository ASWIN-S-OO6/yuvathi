// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'యువతి';

  @override
  String get letsSetYourLanguage => 'మీ భాషను సెట్ చేద్దాం';

  @override
  String get start => 'ప్రారంభించండి';

  @override
  String selectedLanguage(Object language) {
    return 'ఎంచుకోబడినది: @language';
  }

  @override
  String failedToLoad(Object language) {
    return '@language లోడ్ చేయడంలో విఫలమైంది';
  }

  @override
  String get home => 'హోమ్';

  @override
  String get myOrders => 'నా ఆర్డర్లు';

  @override
  String get results => 'ఫలితాలు';

  @override
  String get cart => 'కార్ట్';
}
