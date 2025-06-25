import 'package:flutter/material.dart';
import 'package:yuvathi/screens/payment_page.dart';
import 'package:yuvathi/screens/product_page.dart'; // Assuming cartItems is defined here and accessible
import 'package:yuvathi/widgets/responsive_layout.dart'; // Import the ResponsiveLayout
import 'package:yuvathi/widgets/gradient_background.dart';
import 'cart_page.dart';
import 'home_screen.dart';

// Assuming cartItems is defined in product_page.dart as:
// List<CartItem> cartItems = [];
// And CartItem class is also defined similarly
// If not, you might need to ensure cartItems is properly imported or defined.

class OrderSummaryPage extends StatefulWidget {
  final String? customerName;
  final String? address;

  const OrderSummaryPage({
    Key? key,
    this.customerName,
    this.address, required String phoneNumber,
  }) : super(key: key);

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  bool _isTermsAccepted = false;
  late String _customerName;
  late String _address;
  bool _isEditingAddress = false;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _customerName = widget.customerName ?? 'Lorem Ipsum';
    _address =
        widget.address ??
            'No.2 B, 1th Street, Krishna Nagar, Chennai, Tamil Nadu 641103\nLandmark: Back side school';
    // Initialize quantity from cartItems. If cartItems is empty, default to 1.
    // Ensure `cartItems` is correctly populated before this page is navigated to.
    _quantity = cartItems.isNotEmpty ? cartItems[0].quantity : 1;
    _nameController = TextEditingController(text: _customerName);
    _addressController = TextEditingController(text: _address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 99);
      if (cartItems.isNotEmpty) {
        cartItems[0].quantity = _quantity; // Update quantity in the global cart list
      }
    });
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditingAddress) {
        // If exiting edit mode without saving, revert changes
        _nameController.text = _customerName;
        _addressController.text = _address;
      }
      _isEditingAddress = !_isEditingAddress;
    });
  }

  void _saveChanges() {
    setState(() {
      _customerName = _nameController.text;
      _address = _addressController.text;
      _isEditingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Base font scale for a typical phone width (e.g., 360dp)
    // Clamped to prevent excessive scaling on larger screens (like tablets)
    final double fontScale = (screenWidth / 360.0).clamp(0.8, 1.5);
    // A general responsive factor that can be used for padding, margins, etc.
    // Using 400.0 as a baseline to ensure elements scale appropriately on wider screens like tablets.
    // Clamped to prevent excessive scaling on larger screens (like tablets)
    final double responsiveFactor = (screenWidth / 400.0).clamp(0.8, 1.5);

    // Calculate responsive dimensions
    final appBarHeight = isTablet ? 80.0 * responsiveFactor : 60.0 * responsiveFactor;
    final titleFontSize = isTablet ? 24.0 * fontScale : 18.0 * fontScale;
    final contentPadding = isTablet ? 24.0 * responsiveFactor : 16.0 * responsiveFactor;
    final borderRadius = isTablet ? 16.0 * responsiveFactor : 12.0 * responsiveFactor;
    final imageSize = isTablet ? 120.0 * responsiveFactor : 95.0 * responsiveFactor; // Keep consistent for width and height
    final maxWidth = isTablet ? 800.0 * responsiveFactor : screenWidth; // Max width for content on large screens

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28 * fontScale, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Summary',
          style: TextStyle(
            color: Colors.white,

          ),
        ),
        titleSpacing: 0,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4 * responsiveFactor, vertical: 10 * responsiveFactor),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(borderRadius),
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
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: IntrinsicHeight( // Ensures both sides of the row take up equal height
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill height
                            children: [
                              Container(
                                width: imageSize,
                                height: imageSize, // Use imageSize for height as well
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(borderRadius),
                                    bottomLeft: Radius.circular(borderRadius),
                                  ),
                                  color: Colors.grey,
                                ),
                                child: Image.asset(
                                  cartItems.isNotEmpty
                                      ? cartItems[0].imagePath
                                      : 'assets/product/test_kit1.png', // Fallback image
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        'Product Image\nPlaceholder',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: isTablet ? 14.0 * fontScale : 12.0 * fontScale,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10 * responsiveFactor),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8 * responsiveFactor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Coral Peach Salt Test Kit is simple, Safe, and effective',
                                        style: TextStyle(
                                          fontSize: isTablet ? 16.0 * fontScale : 14.0 * fontScale,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        // Removed maxLines and overflow for full text display
                                      ),
                                      SizedBox(height: 4 * responsiveFactor),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isTablet ? 8.0 * responsiveFactor : 6.0 * responsiveFactor,
                                          vertical: isTablet ? 4.0 * responsiveFactor : 2.0 * responsiveFactor,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(4 * responsiveFactor),
                                        ),
                                        child: Text(
                                          'In stock',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isTablet ? 12.0 * fontScale : 10.0 * fontScale,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8 * responsiveFactor),
                                      Row(
                                        children: [
                                          Text(
                                            '₹1399',
                                            style: TextStyle(
                                              fontSize: isTablet ? 20.0 * fontScale : 16.0 * fontScale,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ),
                                          SizedBox(width: 8 * responsiveFactor),
                                          Flexible( // Use Flexible to prevent price text overflow
                                            child: Text(
                                              'MRP ₹2,999',
                                              style: TextStyle(
                                                fontSize: isTablet ? 14.0 * fontScale : 12.0 * fontScale,
                                                color: Colors.grey[600],
                                                decoration:
                                                TextDecoration.lineThrough,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8 * responsiveFactor),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Removed this
                                        children: [
                                          Flexible(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min, // Ensure this inner row is compact
                                              children: [
                                                Text(
                                                  'Quantity',
                                                  style: TextStyle(
                                                    fontSize: isTablet
                                                        ? 14.0 * fontScale
                                                        : 12.0 * fontScale,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(width: 8 * responsiveFactor),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey[300]!,
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.circular(4 * responsiveFactor),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _updateQuantity(-1),
                                                        child: Container(
                                                          width: isTablet
                                                              ? 24.0 * responsiveFactor
                                                              : 18.0 * responsiveFactor,
                                                          height: isTablet
                                                              ? 32.0 * responsiveFactor
                                                              : 28.0 * responsiveFactor,
                                                          alignment: Alignment.center, // Center icon
                                                          child: Icon(
                                                            Icons.remove,
                                                            size: isTablet
                                                                ? 18.0 * responsiveFactor
                                                                : 14.0 * responsiveFactor,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: isTablet
                                                              ? 12.0 * responsiveFactor
                                                              : 8.0 * responsiveFactor,
                                                        ),
                                                        child: Text(
                                                          '$_quantity',
                                                          style: TextStyle(
                                                            fontSize: isTablet
                                                                ? 16.0 * fontScale
                                                                : 14.0 * fontScale,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _updateQuantity(1),
                                                        child: Container(
                                                          width: isTablet
                                                              ? 24.0 * responsiveFactor
                                                              : 18.0 * responsiveFactor,
                                                          height: isTablet
                                                              ? 32.0 * responsiveFactor
                                                              : 28.0 * responsiveFactor,
                                                          alignment: Alignment.center, // Center icon
                                                          child: Icon(
                                                            Icons.add,
                                                            size: isTablet
                                                                ? 18.0 * responsiveFactor
                                                                : 14.0 * responsiveFactor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Moved 60% OFF container here
                                          SizedBox(width: 7 * responsiveFactor), // Space between quantity and discount
                                          Container(
                                            // Removed the right margin as it's now grouped
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 3 * responsiveFactor,
                                              vertical: 4 * responsiveFactor,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFF9800),
                                              borderRadius: BorderRadius.circular(12 * responsiveFactor),
                                            ),
                                            child: Text(
                                              '53% OFF',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9 * fontScale,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
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
                    SizedBox(height: 20 * responsiveFactor),
                    Text(
                      'Price Details',
                      style: TextStyle(
                        fontSize: 16 * fontScale,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12 * responsiveFactor),
                    Container(
                      padding: EdgeInsets.all(16 * responsiveFactor),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8 * responsiveFactor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1 * responsiveFactor,
                            blurRadius: 3 * responsiveFactor,
                            offset: Offset(0, 1 * responsiveFactor),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPriceRow(
                            'Price ($_quantity item${_quantity > 1 ? 's' : ''})',
                            '₹${(2299 * _quantity).toStringAsFixed(0)}',
                            Colors.black87,
                            fontScale,
                          ),
                          SizedBox(height: 8 * responsiveFactor),
                          _buildPriceRow(
                            'GST 18%',
                            '₹${(161.82 * _quantity).toStringAsFixed(2)}',
                            Colors.black87,
                            fontScale,
                          ),
                          SizedBox(height: 8 * responsiveFactor),
                          _buildPriceRow(
                            'Discount',
                            '-₹${(399 * _quantity).toStringAsFixed(0)}',
                            Theme.of(context).primaryColor,
                            fontScale,
                          ),
                          SizedBox(height: 8 * responsiveFactor),
                          _buildPriceRow(
                            'Shipping charges',
                            'FREE',
                            Colors.green,
                            fontScale,
                          ),
                          SizedBox(height: 12 * responsiveFactor),
                          Container(height: 1 * responsiveFactor, color: Colors.grey[300]),
                          SizedBox(height: 12 * responsiveFactor),
                          _buildPriceRow(
                            'Total Amount',
                            '₹${(1060.82 * _quantity).toStringAsFixed(2)}',
                            Colors.black,
                            fontScale,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20 * responsiveFactor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: _toggleEditMode,
                          child: Text(
                            _isEditingAddress ? 'Cancel' : 'Edit Address',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14 * fontScale,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * responsiveFactor),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16 * responsiveFactor),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8 * responsiveFactor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1 * responsiveFactor,
                            blurRadius: 3 * responsiveFactor,
                            offset: Offset(0, 1 * responsiveFactor),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isEditingAddress
                              ? TextField(
                            controller: _nameController,
                            enabled: true,
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Name',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10 * responsiveFactor,
                                vertical: 10 * responsiveFactor,
                              ),
                              isDense: true, // Make text field more compact
                            ),
                          )
                              : Text(
                            _customerName,
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4 * responsiveFactor),
                          _isEditingAddress
                              ? TextField(
                            controller: _addressController,
                            enabled: true,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Address',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10 * responsiveFactor,
                                vertical: 10 * responsiveFactor,
                              ),
                              isDense: true, // Make text field more compact
                            ),
                          )
                              : Text(
                            _address,
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              color: Colors.black87,
                            ),
                          ),
                          if (_isEditingAddress) ...[
                            SizedBox(height: 16 * responsiveFactor),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12 * responsiveFactor),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16 * responsiveFactor,
                                    vertical: 8 * responsiveFactor,
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14 * fontScale,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16 * responsiveFactor),
                    Container(
                      padding: EdgeInsets.all(12 * responsiveFactor),
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(8 * responsiveFactor),
                      ),
                      child: Text(
                        '*Due To Sanitary Reasons, This Product Is Non-Returnable & Non-Refundable.',
                        style: TextStyle(
                          fontSize: 12 * fontScale,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * responsiveFactor),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale( // Scale checkbox based on responsive factor
                          scale: 1.0 * responsiveFactor,
                          child: Checkbox(
                            value: _isTermsAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isTermsAccepted = value ?? false;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(width: 8 * responsiveFactor),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12 * fontScale,
                                color: Colors.grey[600],
                              ),
                              children: const [ // Made const if possible for performance
                                TextSpan(
                                  text: 'By Purchasing Products Or Services From ',
                                ),
                                TextSpan(
                                  text: '[Aura Biotechnology]',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: ' You Agree To The Following Important ',
                                ),
                                TextSpan(
                                  text: 'Terms And Conditions',
                                  style: TextStyle(
                                    color: Colors.blue, // Explicitly set color here or use Theme.of(context).primaryColor
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24 * responsiveFactor),
                    SizedBox(
                      width: double.infinity,
                      height: 48 * responsiveFactor,
                      child: ElevatedButton(
                        onPressed: _isTermsAccepted
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentPage(),
                            ),
                          );
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24 * responsiveFactor),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * responsiveFactor,
                            vertical: 8 * responsiveFactor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Proceed To Pay',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * fontScale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8 * responsiveFactor),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 20 * responsiveFactor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * responsiveFactor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
      String label,
      String value,
      Color valueColor,
      double fontScale, // Pass fontScale
          {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 * fontScale : 14 * fontScale,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 * fontScale : 14 * fontScale,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}