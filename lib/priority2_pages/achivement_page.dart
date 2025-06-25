import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/translated_text.dart';


class AchievementsPage extends StatelessWidget {
  final List<Map<String, String>> achievements = [
    {'path': 'assets/achivement/gujarat1.png', 'name': 'Nirali cancer Hospital (Navsari)'},
    {'path': 'assets/achivement/gujarat2.png', 'name': 'Bidada Sarvodaya Trust Hospital – BHUJ (Kutch)'}, // Example name
    {'path': 'assets/achivement/gujarat3.png', 'name': 'Kharel Hospital, Gram Seva Trust (Kharel)'}, // Example name
    {'path': 'assets/achivement/gujarat4.png', 'name': 'Upleta Government Hospital. (Rajkot)'},
  ];
  final double minItemWidth = 140.0;
  final double maxItemWidth = 250.0;


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // This sets Nunito as the default font for the entire text theme
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.nunito().fontFamily,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            // Custom App Bar with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink[300]!,
                    Colors.pink[400]!,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      TranslatedText(
                        'Achievements',
                        style: TextStyle( // Removed explicit font family here
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // Recognition & Impact Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TranslatedText(
                            'Recognition & Impact',
                            style: TextStyle( // Removed explicit font family here
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 16),

                          Center(
                            child: Container(
                              height: 150,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15)

                              ),

                              child: Image.asset('assets/achivement/achivement1.png',
                                fit: BoxFit.fitWidth,),
                            ),
                          ),
                          SizedBox(height: 18),



                          _buildAchievementItem(
                            '1.',
                            'Tamil Nadu',
                            'Official launch of our HPV detection kits- Cervi-Prep® by the deputy Chief minister.',
                          ),
                          Center(
                            child: Container(
                              height: 150,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              // Wrap the Image.asset with ClipRRect to ensure it respects the border radius
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15), // Apply the same border radius here
                                child: Image.asset(
                                  'assets/achivement/achivement_tn.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),


                          _buildAchievementItem(
                            '2.',
                            'Karnataka Pilot Program:',
                            ' Pilot program conducted study at Karnataka assembly , Vidhana Soudha and Vikasa Soudha women employees on June 6-8th of June 2024 as part of their health Camp in collaboration with Karnataka Cancer Society, showcasing the effectiveness of our screening solutions.Recognized by the Health Minister of Karnataka, our pilot HPV screening program was conducted at Vidhana Soudha and Aluru Soudha in collaboration with the Karnataka Cancer Society, providing essential screening for government employees.',
                          ),

                          Center(
                            child: Wrap(
                              spacing: 18.0, // Horizontal space between images
                              runSpacing: 18.0, // Vertical space between rows of images if they wrap
                              alignment: WrapAlignment.center, // Aligns items horizontally in the center
                              children: [
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/achivement/kn_pilot.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/achivement/kn_pilot2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/achivement/kn_pilot3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18),
                          _buildAchievementItem(
                            '3.',
                            'Karnataka Cancer Society Partnership:',
                            "Through our partnership with the Karnataka Cancer Society, we have contributed more than ₹20 lakhs worth of free HPV testing kits, reinforcing our commitment to women's health and validating the reliability of our Cervi-Prep® solutions in large-scale, real-world settings it continues.",
                          ),

                          Center(
                            child: Container(
                              height: 150,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              // Wrap the Image.asset with ClipRRect to ensure it respects the border radius
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15), // Apply the same border radius here
                                child: Image.asset(
                                  'assets/achivement/kn_cancer_socity.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),


                          _buildAchievementItem(
                            '4.',
                            'Madhya Pradesh - Indore:',
                            '•  In partnership with Robert Nursing Home and the Association of Indian Physicians of Northern Ohio and Rotory Club of Indore, we provided Cervi-Prep® kits for HPV screening studies. The sample were sent to Aura Biotechnologies Pvt. Ltd. State of art facility and cervi prep collected samples processing and analysis are conducted in Certified laboratories, ',
                          ),

                          Center(
                            child: Container(
                              height: 150,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              // Wrap the Image.asset with ClipRRect to ensure it respects the border radius
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15), // Apply the same border radius here
                                child: Image.asset(
                                  'assets/achivement/mp_indore.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),



                          _buildAchievementItem(
                            '5.',
                            'FOGSI One Day Conference:',
                            'Participated in the FEM Power conference on reproductive health, organized by The Federation of Obstetric and Gynaecological Societies of India (FOGSI) and the Bangalore Society of Obstetrics & Gynaecology on June 29th, 2024, where we introduced CERVI-PREP® to gynecologists from across Bangalore and Karnataka',
                          ),
                          Center(
                            child: Wrap(
                              spacing: 18.0, // Horizontal space between images
                              runSpacing: 18.0, // Vertical space between rows of images if they wrap
                              alignment: WrapAlignment.center, // Aligns items horizontally in the center
                              children: [
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/achivement/fog.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/achivement/fog1.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18),


                          _buildAchievementItem(
                            '6.',
                            'Gujarat:',
                            '10-day screening camp with APNO Medical Yatra (USA) across hospitals including Nikol Hospital, Kheda Hospital, Gam Seva Trust, Bhabla Sarvodaya Trust Hospital, and Hunda Hospital.\n\nThousands of women were screened with Cervi-Prep and HPV Pro Alert Real-Time PCR Kit. Additionally, our sample collection kit attracted diverse regions.',
                          ),

                          // Fixed Gujarat images section - each image with its name below
                          Center(
                            child: Wrap(
                              spacing: 18.0, // Horizontal space between image-name groups
                              runSpacing: 18.0, // Vertical space between rows if they wrap
                              alignment: WrapAlignment.center, // Aligns items horizontally in the center
                              children: achievements.map((achievement) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          achievement['path']!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8), // Space between image and text
                                    Container(
                                      width: 250, // Same width as image to align text properly
                                      child: Text(
                                        achievement['name']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle( // Removed explicit font family here
                                          fontSize: 12, // Decreased font size
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            child: TranslatedText(
              number,
              style: TextStyle( // Removed explicit font family here
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.pink[400],
                fontFamily: GoogleFonts.nunito(
                ).fontFamily
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title ',
                    style: TextStyle( // Removed explicit font family here
                      fontSize: 14,
                      fontFamily: GoogleFonts.nunito(
                      ).fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink[400],
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle( // Removed explicit font family here
                      fontSize: 14,
                      fontFamily: GoogleFonts.nunito(
                      ).fontFamily,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}