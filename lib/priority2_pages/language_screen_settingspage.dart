import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/locale_provider.dart'; // Adjust path to your project
import '../service/translated_text.dart';

class LanguageScreen2 extends StatefulWidget {
  const LanguageScreen2({super.key});

  @override
  State<LanguageScreen2> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen2> {
  String _selectedLanguage = 'English';
  bool _isLoading = false; // Added for loading feedback during model download

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English', 'logo': 'assets/lang_settings/english.png'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'logo': 'assets/lang_settings/tamil.png'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'logo': 'assets/lang_settings/hindi.png'},
    {'name': 'Malayalam', 'native': 'മലയാളം', 'logo': 'assets/lang_settings/malayalam.png'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'logo': 'assets/lang_settings/kannada.png'},
    {'name': 'Telugu', 'native': 'తెలుగు', 'logo': 'assets/lang_settings/telugu.png'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selected language from LocaleProvider
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    setState(() {
      _selectedLanguage = localeProvider.selectedLanguageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFFB6C1),
                ],
              ),
            ),
            child: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const TranslatedText(
                          'Language',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Language List
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            itemCount: _languages.length,
                            itemBuilder: (context, index) {
                              final language = _languages[index];
                              final name = language['name'] ?? 'Unknown';
                              final native = language['native'] ?? 'Unknown';
                              final logo = language['logo'] ?? 'assets/lang_settings/default.png';
                              final isSelected = _selectedLanguage == name;

                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B9D).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      logo,
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        CupertinoIcons.globe,
                                        color: Color(0xFFFF6B9D),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  title: TranslatedText(
                                    native,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Radio<String>(
                                    value: name,
                                    groupValue: _selectedLanguage,
                                    onChanged: (String? value) async {
                                      if (value != null) {
                                        setState(() {
                                          _selectedLanguage = value;
                                          _isLoading = true;
                                        });
                                        // Update LocaleProvider
                                        await localeProvider.setLocale(value);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        // Show confirmation
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: TranslatedText(
                                              'Language set to $value',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    activeColor: const Color(0xFFFF6B9D),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      _selectedLanguage = name;
                                      _isLoading = true;
                                    });
                                    // Update LocaleProvider
                                    await localeProvider.setLocale(name);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    // Show confirmation
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: TranslatedText(
                                          'Language set to $name',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        // Confirm Button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Apply the selected language and return
                                await localeProvider.setLocale(_selectedLanguage);
                                setState(() {
                                  _isLoading = false;
                                });
                                // Show confirmation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: TranslatedText(
                                      'Language settings saved',
                                    ),
                                  ),
                                );
                                // Return to previous screen
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B9D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : const TranslatedText(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B9D),
                ),
              ),
            ),
        ],
      ),
    );
  }
}