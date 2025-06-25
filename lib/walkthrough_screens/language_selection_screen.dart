import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/locale_provider.dart';
import '../service/translated_text.dart';
import 'login_page.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> languages = const [
    {'name': 'English', 'image': 'assets/lang/english.png'},
    {'name': 'Tamil', 'image': 'assets/lang/tamil.png'},
    {'name': 'Malayalam', 'image': 'assets/lang/malayalam.png'},
    {'name': 'Hindi', 'image': 'assets/lang/hindi.png'},
    {'name': 'Telugu', 'image': 'assets/lang/telengu.png'},
    {'name': 'Kannada', 'image': 'assets/lang/kannadam.png'},
  ];

  @override
  void initState() {
    super.initState();
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    setState(() {
      _selectedLanguage = localeProvider.selectedLanguageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const TranslatedText(
          'Let\'s set your language',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.9,
              ),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final languageName = languages[index]['name']!;
                final isSelected = _selectedLanguage == languageName;
                return _buildLanguageCard(
                  context,
                  languageName: languageName,
                  imagePath: languages[index]['image']!,
                  isSelected: isSelected,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  localeProvider.setLocale(_selectedLanguage);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TranslatedText(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
      BuildContext context, {
        required String languageName,
        required String imagePath,
        required bool isSelected,
      }) {
    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          setState(() {
            _selectedLanguage = languageName;
          });
          await Provider.of<LocaleProvider>(context, listen: false)
              .setLocale(languageName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TranslatedText(
                'Selected language: $languageName',
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: Center(
                  child: TranslatedText(
                    'Failed to load $languageName',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}