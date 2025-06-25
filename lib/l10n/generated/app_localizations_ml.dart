// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'യുവതി';

  @override
  String get letsSetYourLanguage => 'നിന്റെ ഭാഷ സെറ്റ് ചെയ്യാം';

  @override
  String get start => 'തുടങ്ങുക';

  @override
  String selectedLanguage(Object language) {
    return 'തിരഞ്ഞെടുത്തത്: @language';
  }

  @override
  String failedToLoad(Object language) {
    return '@language ലോഡ് ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു';
  }

  @override
  String get home => 'ഹോം';

  @override
  String get myOrders => 'എന്റെ ഓർഡറുകൾ';

  @override
  String get results => 'ഫലങ്ങൾ';

  @override
  String get cart => 'കാർട്ട്';
}
