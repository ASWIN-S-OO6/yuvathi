import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Placeholder for your HomeScreen; replace with your actual import
import '../screens/home_screen.dart';
import '../service/translated_text.dart';

class OtpVerifiedScreen extends StatefulWidget {
  const OtpVerifiedScreen({super.key});

  @override
  State<OtpVerifiedScreen> createState() => _OtpVerifiedScreenState();
}

class _OtpVerifiedScreenState extends State<OtpVerifiedScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to HomeScreen after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Gradient container at the top
          Container(
            width: double.infinity,
            height: screenHeight * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.pink.shade50.withOpacity(0.9),
                  Colors.pink.shade50.withOpacity(0.3),
                  Colors.white.withOpacity(0.7),
                  Colors.white,
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
          ),
          // Center the GIF and text together
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GIF
                  Image.asset(
                    'assets/icon/heartrbg.gif',
                    fit: BoxFit.contain,
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 100,
                            color: Colors.green.shade400,
                          ),
                          Text(
                            'Image not found\nPlaceholder',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20), // Space between GIF and text
                  // Text below the GIF
                  TranslatedText(
                    'Yuvathi',
                    style: GoogleFonts.abrilFatface(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  TranslatedText(
                    'OTP Verified',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  // Uncomment if you want to keep the button
                  /*
                  const SizedBox(height: 30),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        _timer.cancel(); // Cancel the timer if user navigates manually
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  */
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}