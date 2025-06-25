import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yuvathi/components/My_drawer.dart';
import 'package:yuvathi/orders/myordersPage1.dart';
import 'package:yuvathi/screens/notification_screen.dart';
import 'package:yuvathi/screens/product_page.dart' hide CartItem;
import 'package:yuvathi/screens/result_page.dart';
import 'package:yuvathi/components/offline_popup.dart';
import '../components/cart_manager.dart';
import '../duplicate/cart2.dart';
import '../l10n/generated/app_localizations.dart';
import '../service/locale_provider.dart';
import '../service/translated_text.dart';
import '../service/translation_service.dart';
import 'cart_page.dart';
// Import the generated AppLocalizations file


final GlobalKey<_HomeScreenState> homeScreenKey = GlobalKey<_HomeScreenState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isShowingPopup = false;

  late ConnectivityResult _lastConnectivityResult; // Store the last known state

  // Define tablet breakpoint and scale factors
  static const double _kTabletBreakpoint = 600.0;
  static const double _kTabletFontScaleFactor = 0.85; // Adjust as needed, e.g., 0.8 for 20% reduction
  static const double _kTabletResponsiveScaleFactor = 0.85; // Adjust as needed

  // Original tab titles
  final List<String> _tabTitles = ['Yuvathi', 'My Orders', 'Results', 'Cart'];
  List<String> _translatedTabTitles = []; // List for translated titles (used for non-AppLocalizations tabs)
  String _currentLanguageCode = ''; // Track current language for custom translation


  @override
  void initState() {
    super.initState();
    _translatedTabTitles = List.from(_tabTitles); // Initialize with original titles
    _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen(_checkConnectivity);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeProvider = Provider.of<LocaleProvider>(context);
    final targetLanguageCode =
        TranslationService.supportedLanguages[localeProvider.selectedLanguageName] ?? 'en';

    if (_currentLanguageCode != targetLanguageCode) {
      _currentLanguageCode = targetLanguageCode;
      _translateBottomNavLabels(); // Trigger translation for bottom nav labels
    }
  }

  Future<void> _translateBottomNavLabels() async {
    List<String> newTranslatedTitles = [];
    for (String title in _tabTitles) {
      String translated = await TranslationService.translate(title, _currentLanguageCode);
      newTranslatedTitles.add(translated);
    }
    if (mounted) {
      setState(() {
        _translatedTabTitles = newTranslatedTitles;
      });
    }
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    _lastConnectivityResult = connectivityResults.first; // Assuming only one primary result
    _checkConnectivity(connectivityResults);
  }

  void _checkConnectivity(List<ConnectivityResult> results) {
    bool isOffline = results.contains(ConnectivityResult.none);
    bool wasOffline = _lastConnectivityResult == ConnectivityResult.none;

    // Update the last known connectivity state
    _lastConnectivityResult = results.first;

    if (isOffline) {
      if (!_isShowingPopup) {
        setState(() {
          _isShowingPopup = true;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false, // Prevents closing with back button
              child: OfflinePopup(
                onTryAgain: () async {
                  final connectivityResults = await Connectivity().checkConnectivity();
                  if (!connectivityResults.contains(ConnectivityResult.none)) {
                    // Only pop if online
                    Navigator.of(context).pop();
                    setState(() {
                      _isShowingPopup = false;
                    });
                  }
                },
              ),
            );
          },
        );
      }
    } else {
      // If we were showing the popup and now we are online, dismiss it
      if (_isShowingPopup && wasOffline) { // Only dismiss if it was previously offline
        Navigator.of(context).pop();
        setState(() {
          _isShowingPopup = false;
        });
      }
    }
  }

  void switchToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildSvgIcon(String assetPath, double size, {Color? color}) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool _isTablet = shortestSide >= _kTabletBreakpoint;

    double fontScale = screenWidth / 360.0;
    double responsiveFactor = screenWidth / 400.0;

    if (_isTablet) {
      fontScale *= _kTabletFontScaleFactor;
      responsiveFactor *= _kTabletResponsiveScaleFactor;
    }

    // Safely get the AppLocalizations instance
    final appLocalizations = AppLocalizations.of(context);

    // Determine AppBar title
    Widget appBarTitleWidget;
    if (_selectedIndex == 0 && appLocalizations != null) {
      appBarTitleWidget = Text(
        appLocalizations.appTitle, // Using appTitle from AppLocalizations
        style: GoogleFonts.abrilFatface(
          fontSize: 23 * fontScale,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    } else {
      // Fallback to TranslatedText for other tabs if AppLocalizations getters are not available
      appBarTitleWidget = TranslatedText(
        _tabTitles[_selectedIndex],
        style: GoogleFonts.abrilFatface(
          fontSize: 23 * fontScale,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }

    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      initialData: const [ConnectivityResult.wifi],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkConnectivity(snapshot.data!);
          });
        }

        return WillPopScope(
          onWillPop: () async {
            if (_selectedIndex != 0) {
              setState(() {
                _selectedIndex = 0;
              });
              return false;
            }
            return true;
          },
          child: Scaffold(
            key: homeScreenKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              foregroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
              actionsIconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appBarTitleWidget, // Use the determined widget
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(CupertinoIcons.bell, size: 20 * responsiveFactor),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const NotificationPage()),
                    );
                  },
                ),
                SizedBox(width: 4 * responsiveFactor),
              ],
              centerTitle: false,
            ),
            drawer: const NavigationScreen(),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                HomeTabContent(fontScale: fontScale, responsiveFactor: responsiveFactor),
                const MyOrdersTabContent(),
                const ResultsTabContent(),
                const CartTabContent(),
              ],
            ),
            floatingActionButton: null,
            extendBody: true,
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(15 * responsiveFactor),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25 * responsiveFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10 * responsiveFactor,
                    offset: Offset(0, -2 * responsiveFactor),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25 * responsiveFactor),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey[600],
                  selectedLabelStyle: TextStyle(
                    fontSize: 12 * fontScale,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12 * fontScale,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                    color: Colors.grey[800],
                  ),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  iconSize: 20 * responsiveFactor,
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: Icon(CupertinoIcons.house, size: 20 * responsiveFactor),
                      ),
                      label: (_selectedIndex == 0 && appLocalizations != null)
                          ? appLocalizations.appTitle
                          : (_translatedTabTitles.isNotEmpty ? _translatedTabTitles[0] : 'Home'),
                      activeIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: Icon(
                          CupertinoIcons.house,
                          size: 20 * responsiveFactor,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: buildSvgIcon(
                          'assets/icon/orders.svg',
                          20 * responsiveFactor,
                          color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.grey[600],
                        ),
                      ),
                      label: _translatedTabTitles.isNotEmpty ? _translatedTabTitles[1] : 'My Orders',
                      activeIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: buildSvgIcon(
                          'assets/icon/orders.svg',
                          20 * responsiveFactor,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: Icon(FontAwesomeIcons.magnifyingGlassChart, size: 20 * responsiveFactor),
                      ),
                      label: _translatedTabTitles.isNotEmpty ? _translatedTabTitles[2] : 'Results',
                      activeIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: Icon(
                          FontAwesomeIcons.magnifyingGlassChart,
                          size: 20 * responsiveFactor,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: Icon(CupertinoIcons.cart, size: 20 * responsiveFactor),
                      ),
                      label: _translatedTabTitles.isNotEmpty ? _translatedTabTitles[3] : 'Cart',
                      activeIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4 * responsiveFactor),
                        child: Icon(
                          CupertinoIcons.cart,
                          size: 20 * responsiveFactor,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeTabContent extends StatelessWidget {
  final double fontScale;
  final double responsiveFactor;

  const HomeTabContent({
    super.key,
    required this.fontScale,
    required this.responsiveFactor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final double bannerHeight = screenHeight * 0.25;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0 * responsiveFactor, vertical: 0 * responsiveFactor),
            child: Container(
              width: double.infinity,
              height: bannerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16 * responsiveFactor),
                color: Colors.pink.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100.withOpacity(0.5),
                    blurRadius: 12 * responsiveFactor,
                    spreadRadius: 2 * responsiveFactor,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16 * responsiveFactor),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/homepic.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: TranslatedText(
                                'HPV Banner Image\nPlaceholder',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[600], fontSize: 12 * fontScale),
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
          Padding(
            padding: EdgeInsets.fromLTRB(12 * responsiveFactor, 16 * responsiveFactor, 12 * responsiveFactor, 8 * responsiveFactor),
            child: TranslatedText(
              'Our Product',
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12 * responsiveFactor),
            child: IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12 * responsiveFactor),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.0 * responsiveFactor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8 * responsiveFactor,
                      spreadRadius: 1.5 * responsiveFactor,
                      offset: Offset(0, 4 * responsiveFactor),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12 * responsiveFactor),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          height: 140 * responsiveFactor,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10 * responsiveFactor),
                              bottomLeft: Radius.circular(10 * responsiveFactor),
                            ),
                            color: Colors.grey[100],
                          ),
                          child: Image.asset(
                            'assets/product/test_kit1.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  'Product Image\nPlaceholder',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12 * fontScale),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.all(12 * responsiveFactor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TranslatedText(
                                'Cervi-Prep® Self-Test Kit is simple, safe, and effective.',
                                style: TextStyle(
                                  fontSize: 15 * fontScale,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6 * responsiveFactor),
                              Row(
                                children: [
                                  TranslatedText(
                                    '₹1399',
                                    style: TextStyle(
                                      fontSize: 12 * fontScale,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 6 * responsiveFactor),
                                  Flexible(
                                    child: TranslatedText(
                                      'MRP ₹2,999',
                                      style: TextStyle(
                                        fontSize: 12 * fontScale,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 6 * responsiveFactor),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4 * responsiveFactor, vertical: 1 * responsiveFactor),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(4 * responsiveFactor),
                                    ),
                                    child: TranslatedText(
                                      '53% OFF',
                                      style: TextStyle(
                                        fontSize: 10 * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6 * responsiveFactor),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 14 * responsiveFactor),
                                  SizedBox(width: 3 * responsiveFactor),
                                  TranslatedText(
                                    '4.8',
                                    style: TextStyle(color: Colors.grey[700], fontSize: 12 * fontScale),
                                  ),
                                  SizedBox(width: 3 * responsiveFactor),
                                  TranslatedText(
                                    '(187)',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12 * fontScale),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12 * responsiveFactor),
                              SizedBox(
                                width: double.infinity,
                                height: 40 * responsiveFactor,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ProductPage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25 * responsiveFactor),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8 * responsiveFactor),
                                  ),
                                  child: TranslatedText(
                                    'Buy',
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12 * responsiveFactor, 24 * responsiveFactor, 12 * responsiveFactor, 8 * responsiveFactor),
            child: TranslatedText(
              'Why HPV Screening Matters',
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12 * responsiveFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  'Human Papillomavirus (HPV) Is The Leading Cause Of Cervical Cancer, Impacting Thousands Of Women Worldwide. Regular Screening And Early Detection Can Significantly Reduce Your Risk Of Complications.',
                  style: TextStyle(fontSize: 12 * fontScale, color: Colors.grey[700]),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12 * responsiveFactor),
                TranslatedText(
                  'The Yuvathi.Health HPV Screening Kit Offers:',
                  style: TextStyle(
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 8 * responsiveFactor),
                Container(
                  padding: EdgeInsets.all(12 * responsiveFactor),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12 * responsiveFactor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withOpacity(0.5),
                        blurRadius: 8 * responsiveFactor,
                        spreadRadius: 1 * responsiveFactor,
                        offset: Offset(0, 2 * responsiveFactor),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint(
                        'Accurate Detection: Detects 14 High-Risk HPV Types Linked To Cervical Cancer Using The HPV PRO ALERT® Real-Time PCR Kit.',
                        fontScale,
                        responsiveFactor,
                      ),
                      _buildBulletPoint(
                        'Early Diagnosis: Enables Timely Action To Improve Health Outcomes.',
                        fontScale,
                        responsiveFactor,
                      ),
                      _buildBulletPoint(
                        'Accessible & Affordable: Designed To Reach Women From All Walks Of Life.',
                        fontScale,
                        responsiveFactor,
                      ),
                      _buildBulletPoint(
                        'Home Convenience: Self-Test Ensures Privacy And Comfort.',
                        fontScale,
                        responsiveFactor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 90 * responsiveFactor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, double fontScale, double responsiveFactor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0 * responsiveFactor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            '• ',
            style: TextStyle(fontSize: 12 * fontScale, color: Colors.grey[700]),
          ),
          Expanded(
            child: TranslatedText(
              text,
              builder: (context, translatedText) {
                final parts = translatedText.split(':');
                final subtitle = parts[0].trim();
                final description = parts.length > 1 ? parts[1].trim() : '';

                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: subtitle,
                        style: TextStyle(
                          fontSize: 12 * fontScale,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        TextSpan(
                          text: ': ',
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            color: Colors.grey[700],
                          ),
                        ),
                        TextSpan(
                          text: description,
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyOrdersTabContent extends StatelessWidget {
  const MyOrdersTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MyOrdersPage();
  }
}

class ResultsTabContent extends StatelessWidget {
  const ResultsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ResultsPage();
  }
}

class CartTabContent extends StatelessWidget {
  const CartTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartPage(showAppBar: false);
  }
}