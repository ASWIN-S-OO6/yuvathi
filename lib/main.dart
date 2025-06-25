import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuvathi/priority2_pages/splash_screen.dart';
import 'package:yuvathi/walkthrough_screens/onboarding_screen.dart';
import 'package:yuvathi/components/cart_manager.dart';
import 'package:yuvathi/l10n/generated/app_localizations.dart';
import 'package:yuvathi/service/locale_provider.dart';
import 'package:yuvathi/bloc/language/language_bloc.dart';
import 'package:yuvathi/bloc/language/language_state.dart';
import 'package:yuvathi/widgets/gradient_background.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartManager()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        BlocProvider(create: (context) => LanguageBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Yuvathi',
          theme: ThemeData(
            primaryColor: const Color(0xFFFF6D9B),
            textTheme: GoogleFonts.nunitoTextTheme(),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          locale: state.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ta', 'IN'),
            Locale('ml', 'IN'),
            Locale('hi', 'IN'),
            Locale('te', 'IN'),
            Locale('kn', 'IN'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}
