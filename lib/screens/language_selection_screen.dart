import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuvathi/bloc/language/language_bloc.dart';
import 'package:yuvathi/bloc/language/language_event.dart';
import 'package:yuvathi/widgets/gradient_background.dart';
import 'package:yuvathi/widgets/responsive_layout.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'English', 'code': 'en', 'country': 'US'},
      {'name': 'தமிழ்', 'code': 'ta', 'country': 'IN'},
      {'name': 'മലയാളം', 'code': 'ml', 'country': 'IN'},
      {'name': 'हिंदी', 'code': 'hi', 'country': 'IN'},
      {'name': 'తెలుగు', 'code': 'te', 'country': 'IN'},
      {'name': 'ಕನ್ನಡ', 'code': 'kn', 'country': 'IN'},
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: ResponsiveLayout.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: ResponsiveLayout.getResponsiveFontSize(
                      context,
                      24,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveLayout.isTablet(context)
                          ? 3
                          : 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      return ElevatedButton(
                        onPressed: () {
                          context.read<LanguageBloc>().add(
                            ChangeLanguage(
                              languageCode: language['code']!,
                              countryCode: language['country']!,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.pink[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          language['name']!,
                          style: TextStyle(
                            fontSize: ResponsiveLayout.getResponsiveFontSize(
                              context,
                              18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
