import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OfflinePopup extends StatelessWidget {
  final VoidCallback? onTryAgain;

  const OfflinePopup({Key? key, this.onTryAgain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5A5A5A), // Dark grey background
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SVG Icon
              Container(
                width: 80,
                height: 80,
                child: SvgPicture.string(
                  '''
                  <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <!-- Monitor Screen -->
                    <rect x="15" y="20" width="70" height="45" rx="3" ry="3" 
                          fill="none" stroke="#2563EB" stroke-width="3"/>
                    
                    <!-- Monitor Stand -->
                    <line x1="50" y1="65" x2="50" y2="75" 
                          stroke="#2563EB" stroke-width="3"/>
                    
                    <!-- Monitor Base -->
                    <line x1="35" y1="75" x2="65" y2="75" 
                          stroke="#2563EB" stroke-width="3" stroke-linecap="round"/>
                    
                    <!-- Warning Triangle Background -->
                    <circle cx="50" cy="37" r="12" fill="#FCD34D"/>
                    
                    <!-- Warning Triangle -->
                    <path d="M45 32 L55 32 L52 45 L48 45 Z" fill="#F59E0B"/>
                    
                    <!-- Warning Dot -->
                    <circle cx="50" cy="48" r="1.5" fill="#F59E0B"/>
                    
                    <!-- Network Lines -->
                    <rect x="25" y="55" width="50" height="2" fill="#2563EB"/>
                    <rect x="30" y="58" width="40" height="1" fill="#2563EB"/>
                    <rect x="35" y="60" width="30" height="1" fill="#2563EB"/>
                  </svg>
                  ''',
                  width: 80,
                  height: 80,
                ),
              ),

              SizedBox(height: 25),

              // Title
              Text(
                "It Looks Like You're Offline!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151), // Dark grey text
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 15),

              // Subtitle
              Text(
                "Please check your internet\nconnection and try again.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9CA3AF), // Light grey text
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),

              // Try Again Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onTryAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF4444), // Red color
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Try again",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
