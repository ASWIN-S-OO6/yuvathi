import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'language_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index.toDouble();
              });
            },
            children: [
              _buildWalkthroughPage(
                context,
                imagePath: 'assets/image1.svg',
                title: 'Use the easy self-swab kit from the comfort of your home.',
                subtitle: 'No pain. No clinic visit.',
                pageIndex: 0,
              ),
              _buildWalkthroughPage(
                context,
                imagePath: 'assets/image2.svg',
                title: 'Receive accurate results on your phone within 3-5 days, with follow-up guidance if needed.',
                subtitle: '',
                pageIndex: 1,
              ),
              _buildWalkthroughPage(
                context,
                imagePath: 'assets/image3.svg',
                title: 'Use the pre-paid shipping box to send your sample.',
                subtitle: '',
                pageIndex: 2,
              ),
            ],
          ),
          if (_currentPage > 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          if (_currentPage == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: TextButton(
                onPressed: () {
                  _pageController.jumpToPage(2);
                },
                child: Row(
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                    const SizedBox(width: 3),
                    Icon(Icons.arrow_circle_right, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWalkthroughPage(BuildContext context, {required String imagePath, required String title, required String subtitle, required int pageIndex}) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SvgPicture.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => Center(
                      child: Text(
                        'Loading SVG\n($imagePath)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    semanticsLabel: 'Onboarding image $pageIndex',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 60),
              DotsIndicator(
                dotsCount: 3,
                position: _currentPage,
                decorator: DotsDecorator(
                  color: Colors.grey.shade300,
                  activeColor: Theme.of(context).primaryColor,
                  size: const Size.square(10),
                  activeSize: const Size(22, 9.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      pageIndex == 2 ? 'Continue' : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}