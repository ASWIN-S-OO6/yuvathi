import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yuvathi/screens/checkout_billing_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../service/translated_text.dart';
import 'cart_page.dart';

// Global cart list to store cart items
List<CartItem> cartItems = [];

class CartItem {
  final String title;
  final String imagePath;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final double rating;
  final int reviewCount;
  int quantity;

  CartItem({
    required this.title,
    required this.imagePath,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.quantity,
  });
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();
  bool showBottomButtons = true;
  bool isReviewExpanded = false;
  int quantity = 1;

  final List<String> productImages = [
    'assets/product/product1.jpg',
    'assets/product/product2.jpg',
    'assets/product/product3.jpg',
  ];

  ScrollDirection? _lastScrollDirection;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
  }

  late final YoutubePlayerController youtubeController = YoutubePlayerController(
    initialVideoId: 'vdsv9kJ0J8I',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      enableCaption: true,
      loop: false,
      hideThumbnail: false,
      forceHD: false,
    ),
  );

  void _handleScroll() {
    final currentDirection = scrollController.position.userScrollDirection;

    if (_isUpdating || currentDirection == _lastScrollDirection) return;

    _lastScrollDirection = currentDirection;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _isUpdating = true;
        if (currentDirection == ScrollDirection.reverse) {
          if (showBottomButtons) {
            showBottomButtons = false;
          }
        } else if (currentDirection == ScrollDirection.forward) {
          if (!showBottomButtons) {
            showBottomButtons = true;
          }
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return; // Check if the widget is still mounted
        setState(() {
          _isUpdating = false;
        });
      });
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll); // Remove listener
    scrollController.dispose();
    pageController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final existingItemIndex = cartItems.indexWhere(
          (item) =>
      item.title ==
          'Cervical Cancer Screening Test | At-Home Self Sampling Test | HPV detection',
    );

    if (existingItemIndex != -1) {
      setState(() {
        cartItems[existingItemIndex].quantity += quantity;
      });
    } else {
      setState(() {
        cartItems.add(
          CartItem(
            title:
            'Cervical Cancer Screening Test | At-Home Self Sampling Test | HPV detection',
            imagePath: 'assets/product1.png',
            price: 1399.0,
            originalPrice: 2999.0,
            discountPercentage: 53.0,
            rating: 4.8,
            reviewCount: 187,
            quantity: quantity,
          ),
        );
        // Debug print to confirm addition
        print(
          'Added to cart: ${cartItems.last.title}, Quantity: ${cartItems.last.quantity}',
        );
      });
    }

    String viewcart = TranslatedText('view cart') as String;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TranslatedText('Added $quantity item(s) to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: viewcart,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Base font scale for a typical phone width (e.g., 360dp)
    // Clamped to prevent excessive scaling on larger screens (like tablets)
    final double fontScale = (screenWidth / 360.0).clamp(0.8, 1.5);
    // A general responsive factor that can be used for padding, margins, etc.
    // Clamped to prevent excessive scaling on larger screens (like tablets)
    final double responsiveFactor = (screenWidth / 400.0).clamp(0.8, 1.5);

    // Responsive image height (percentage of screen height)
    final double imageHeight = screenHeight * 0.35;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(
            size: 28,
            Icons.arrow_back,
            color: Colors.white,

          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TranslatedText(
          'Product Details',
          style: TextStyle(color: Colors.white, ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 20 * responsiveFactor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: productImages.length,
                        itemBuilder: (context, index) {
                          return ClipRRect( // Clip images to prevent overflow if aspect ratio changes
                            child: Image.asset(
                              productImages[index],
                              fit: BoxFit.cover, // Use cover to fill the space
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: imageHeight,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: TranslatedText(
                                      'Product Image Placeholder ${index + 1}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12 * fontScale,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 25 * responsiveFactor,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: productImages.length,
                          effect: WormEffect(
                            dotHeight: 8 * responsiveFactor,
                            dotWidth: 8 * responsiveFactor,
                            activeDotColor: Theme.of(context).primaryColor,
                            dotColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: Offset(0, -16 * responsiveFactor),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16 * responsiveFactor),
                        topRight: Radius.circular(16 * responsiveFactor),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8 * responsiveFactor,
                          offset: Offset(0, -2 * responsiveFactor),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 12 * responsiveFactor,
                        bottom: 12 * responsiveFactor,
                        left: 12 * responsiveFactor,
                        right: 12 * responsiveFactor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6 * responsiveFactor,
                                  vertical: 3 * responsiveFactor,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(
                                    10 * responsiveFactor,
                                  ),
                                ),
                                child: TranslatedText(
                                  'In stock',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10 * fontScale,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.share,
                                  color: Theme.of(context).primaryColor,
                                  size: 18 * responsiveFactor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          TranslatedText(
                            'Cervical Cancer Screening Test | At-Home Self Sampling Test | HPV detection',
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          Row(
                            children: [
                              TranslatedText(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 14 * fontScale,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 16 * responsiveFactor),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    6 * responsiveFactor,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        size: 16 * responsiveFactor,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 32 * responsiveFactor,
                                        minHeight: 32 * responsiveFactor,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    Text(
                                      '$quantity',
                                      style: TextStyle(
                                        fontSize: 14 * fontScale,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 16 * responsiveFactor,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 32 * responsiveFactor,
                                        minHeight: 32 * responsiveFactor,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16 * responsiveFactor),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10 * responsiveFactor,
                                  vertical: 4 * responsiveFactor,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(
                                    10 * responsiveFactor,
                                  ),
                                ),
                                child: TranslatedText(
                                  '61% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10 * fontScale,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12 * responsiveFactor),
                          Row(
                            children: [
                              Flexible( // Use Flexible to prevent price text overflow
                                child: TranslatedText(
                                  '₹899',
                                  style: TextStyle(
                                    fontSize: 20 * fontScale,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8 * responsiveFactor),
                              Flexible( // Use Flexible for MRP text
                                child: TranslatedText(
                                  'MRP ₹2,299',
                                  style: TextStyle(
                                    fontSize: 14 * fontScale,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12 * responsiveFactor),
                          Container(
                            padding: EdgeInsets.all(10 * responsiveFactor),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(
                                6 * responsiveFactor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color: Colors.green,
                                  size: 16 * responsiveFactor,
                                ),
                                SizedBox(width: 6 * responsiveFactor),
                                Expanded(
                                  child: TranslatedText(
                                    'FREE delivery Wednesday, 18 June. Details',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12 * fontScale,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16 * responsiveFactor,
                              ),
                              SizedBox(width: 6 * responsiveFactor),
                              Expanded(
                                child: TranslatedText(
                                  'Delivering to Coimbatore 641012 -',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12 * fontScale,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: TranslatedText(
                                  'Update Location',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12 * fontScale,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16 * responsiveFactor),
                          TranslatedText(
                            'Description',
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          Container(
                            padding: EdgeInsets.all(12 * responsiveFactor),
                            decoration: BoxDecoration(
                              color: Colors.pink[50], // Mild pink background
                              borderRadius: BorderRadius.circular(
                                8 * responsiveFactor,
                              ),
                            ),
                            child: Column(
                              children: [
                                for (String point in [
                                  'Accurate Self-Sampling Kit: Allows adult women to screen for Cervical Cancer from home using a simple self-sampling technique.',
                                  'Cervical Cancer Screening: A crucial factor that causes cervical cancer is Human Papillomavirus (HPV) infection.',
                                  'Compliant Control Organisation for Early Oncological Screening: Global Cervical Cancer Screening.',
                                  'Online Results: Get your test results online within days of sending the sample.',
                                  'Early Protection Saves Lives: Regular screening and careful system insights-based screening therapy is highly effective, and can save lives.',
                                ])
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 6.0 * responsiveFactor,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• ',
                                          style: GoogleFonts.nunito(
                                            fontSize: 14 * fontScale,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildHighlightedDescription(
                                            point,
                                            fontScale,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16 * responsiveFactor),
                          TranslatedText(
                            'How to use?',
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          SizedBox(
                            height: screenHeight * 0.40,
                            width: double.infinity,
                            child: YoutubePlayer(
                              controller: youtubeController,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Theme.of(context).primaryColor,
                              progressColors: ProgressBarColors(
                                playedColor: Theme.of(context).primaryColor,
                                handleColor: Theme.of(context).primaryColor,
                              ),
                              onReady: () {
                                print('YouTube Player is ready!');
                                // You can add youtubeController.play() here if you want it to autoplay on ready
                              },
                              onEnded: (metaData) {
                                youtubeController.seekTo(Duration.zero);
                              },
                            ),
                          ),
                          SizedBox(height: 16 * responsiveFactor),
                          TranslatedText(
                            'Instructions',
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5 * responsiveFactor,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: screenHeight * 0.45, // Responsive height for image
                              child: Image.asset(
                                'assets/instructions.png',
                                fit: BoxFit.contain, // Use contain to fit within bounds
                                width: double.infinity,
                                height: screenHeight * 0.45,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: screenHeight * 0.45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(
                                        6 * responsiveFactor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Instructions Image Placeholder',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12 * fontScale,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16 * responsiveFactor),
                          Container(
                            padding: EdgeInsets.all(12 * responsiveFactor),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10 * responsiveFactor,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TranslatedText(
                                  'Kits we used to detect',
                                  style: TextStyle(
                                    fontSize: 14 * fontScale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12 * responsiveFactor),
                                _buildKitCard(
                                  'HPV Pro Alert',
                                  [
                                    'Detects 14 High-Risk HPV Types',
                                    'Accurate Real-Time PCR Technology',
                                    'Quick & Reliable Results',
                                    'Suitable For Clinical Diagnostic needs',
                                  ],
                                  'assets/kit.png',
                                  fontScale,
                                  responsiveFactor, // Pass responsive factor
                                ),
                                SizedBox(height: 12 * responsiveFactor),
                                _buildKitCard(
                                  'HPV High-Risk Real-Time PCR Kit',
                                  [
                                    'Detects 14 High-Risk HPV Types',
                                    'Accurate Real-Time PCR Technology',
                                    'Quick & Reliable Results',
                                    'Suitable For Clinical Diagnostic needs',
                                  ],
                                  'assets/kit.png',
                                  fontScale,
                                  responsiveFactor, // Pass responsive factor
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16 * responsiveFactor),
                          TranslatedText(
                            'Applications & Use Cases',
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10 * responsiveFactor),
                          TranslatedText(
                            'Perfect for:',
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 6 * responsiveFactor),
                          for (String application in [
                            'Routine screening (ages 25-65)',
                            'At-home collection programs',
                            'Health camps, mobile clinics, and community outreach',
                            'Public health initiatives focused on early detection',
                          ])
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.0 * responsiveFactor),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${String.fromCharCode(0x2022)} ',
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded( // Use Expanded for application text
                                    child: Text(
                                      application,
                                      style: TextStyle(
                                        fontSize: 12 * fontScale,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 16 * responsiveFactor),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isReviewExpanded = !isReviewExpanded;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12 * responsiveFactor),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  6 * responsiveFactor,
                                ),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TranslatedText(
                                        'Reviews',
                                        style: TextStyle(
                                          fontSize: 16 * fontScale,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        isReviewExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                        size: 20 * responsiveFactor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10 * responsiveFactor),
                                  Row(
                                    children: [
                                      TranslatedText(
                                        '4.9',
                                        style: TextStyle(
                                          fontSize: 28 * fontScale,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(width: 6 * responsiveFactor),
                                      TranslatedText(
                                        'out of 5',
                                        style: TextStyle(
                                          fontSize: 12 * fontScale,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 12 * responsiveFactor),
                                      Row(
                                        children: List.generate(
                                          5,
                                              (index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16 * responsiveFactor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isReviewExpanded) ...[
                                    SizedBox(height: 12 * responsiveFactor),
                                    for (int i = 5; i >= 1; i--)
                                      _buildReviewBar(
                                        i,
                                        [85, 12, 2, 1, 0][5 - i],
                                        fontScale,
                                        responsiveFactor,
                                      ),
                                    SizedBox(height: 12 * responsiveFactor),
                                    TranslatedText(
                                      '42 Reviews',
                                      style: TextStyle(
                                        fontSize: 12 * fontScale,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 12 * responsiveFactor),
                                    TextButton(
                                      onPressed: () {},
                                      child: TranslatedText(
                                        'WRITE A REVIEW',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12 * fontScale,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12 * responsiveFactor),
                                    _buildReviewItem(
                                      'Jennifer Rose',
                                      4,
                                      'I love it, Absolutely excellent service! I helped me out with so very additional item for my order. Thanks again!',
                                      fontScale,
                                      responsiveFactor,
                                    ),
                                    _buildReviewItem(
                                      'Kelly Rhine',
                                      5,
                                      "I'm very happy with result. It was delivered on get good quality. Recommended.",
                                      fontScale,
                                      responsiveFactor,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 80 * responsiveFactor),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: showBottomButtons,
              child: Container(
                padding: EdgeInsets.all(12 * responsiveFactor),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6 * responsiveFactor,
                      offset: Offset(0, -1.5 * responsiveFactor),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _addToCart,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 8 * responsiveFactor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25 * responsiveFactor),
                          ),
                        ),
                        child: TranslatedText(
                          'Save For Later',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12 * fontScale,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10 * responsiveFactor),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const CheckoutBillingScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: 8 * responsiveFactor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25 * responsiveFactor),
                          ),
                        ),
                        child: TranslatedText(
                          'Buy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12 * fontScale,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitCard(
      String title,
      List<String> features,
      String imagePath,
      double fontScale,
      double responsiveFactor, // Pass responsive factor
      ) {
    return IntrinsicHeight( // Ensure both columns take same height
      child: Container(
        padding: EdgeInsets.all(10 * responsiveFactor),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6 * responsiveFactor),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill IntrinsicHeight
          children: [
            SizedBox( // Use SizedBox with fixed aspect ratio based on responsiveFactor
              width: 100 * responsiveFactor, // Adjusted fixed width for image
              height: 120 * responsiveFactor, // Adjusted fixed height for image
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100 * responsiveFactor,
                    height: 120 * responsiveFactor,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6 * responsiveFactor),
                    ),
                    child: Center(
                      child: Text(
                        '${title} Image Placeholder',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12 * fontScale,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10 * responsiveFactor),
            Expanded( // Use Expanded for the text content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    title,
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 8 * responsiveFactor), // Reduced space
                  for (String feature in features)
                    Padding(
                      padding: EdgeInsets.only(bottom: 3 * responsiveFactor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              color: Colors.black54,
                            ),
                          ),
                          Expanded( // Expanded for feature text
                            child: TranslatedText(
                              feature,
                              style: TextStyle(
                                fontSize: 10 * fontScale,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(), // Pushes content to the top
                  SizedBox(height: 6 * responsiveFactor),
                  TranslatedText(
                    '05:33 PM IST on Tuesday, June 17, 2025',
                    style: TextStyle(
                      fontSize: 10 * fontScale,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedDescription(String point, double fontScale) {
    final parts = point.split(':');
    if (parts.length < 2) {
      return Text(
        point,
        style: GoogleFonts.nunito(
          fontSize: 13 * fontScale,
          color: Colors.black87,
          height: 1.4,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${parts[0]}:',
            style: GoogleFonts.nunito(
              fontSize: 13 * fontScale,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          TextSpan(
            text: parts[1],
            style: GoogleFonts.nunito(
              fontSize: 13 * fontScale,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildReviewBar(int stars, int percentage, double fontScale, double responsiveFactor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3 * responsiveFactor),
      child: Row(
        children: [
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                Icons.star,
                color: index < stars ? Colors.amber : Colors.grey.shade300,
                size: 14 * responsiveFactor,
              ),
            ),
          ),
          SizedBox(width: 6 * responsiveFactor),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 4 * responsiveFactor,
            ),
          ),
          SizedBox(width: 6 * responsiveFactor),
          Text(
            '${percentage}%',
            style: TextStyle(fontSize: 10 * fontScale, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      String name,
      int rating,
      String review,
      double fontScale,
      double responsiveFactor,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12 * responsiveFactor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16 * responsiveFactor,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              name[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12 * fontScale,
              ),
            ),
          ),
          SizedBox(width: 10 * responsiveFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * fontScale,
                  ),
                ),
                SizedBox(height: 3 * responsiveFactor),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      Icons.star,
                      color: index < rating
                          ? Colors.amber
                          : Colors.grey.shade300,
                      size: 14 * responsiveFactor,
                    ),
                  ),
                ),
                SizedBox(height: 6 * responsiveFactor),
                Text(
                  review,
                  style: TextStyle(
                    fontSize: 11 * fontScale,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}