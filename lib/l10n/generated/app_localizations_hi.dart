// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'युवती';

  @override
  String get letsSetYourLanguage => 'आइए अपनी भाषा सेट करें';

  @override
  String get start => 'शुरू करें';

  @override
  String selectedLanguage(Object language) {
    return 'चयनित: @language';
  }

  @override
  String failedToLoad(Object language) {
    return '@language लोड करने में विफल';
  }

  @override
  String get home => 'होम';

  @override
  String get myOrders => 'मेरे ऑर्डर';

  @override
  String get results => 'परिणाम';

  @override
  String get cart => 'कार्ट';
}
