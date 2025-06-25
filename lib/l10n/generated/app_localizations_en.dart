// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yuvathi';

  @override
  String get letsSetYourLanguage => 'Let\'s Set Your Language';

  @override
  String get start => 'Start';

  @override
  String selectedLanguage(Object language) {
    return 'Selected: @language';
  }

  @override
  String failedToLoad(Object language) {
    return 'Failed to load @language';
  }

  @override
  String get home => 'Home';

  @override
  String get myOrders => 'My Orders';

  @override
  String get results => 'Results';

  @override
  String get cart => 'Cart';
}
