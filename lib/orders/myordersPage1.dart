import 'package:flutter/material.dart';
import 'package:yuvathi/screens/result_page.dart';

import '../service/translated_text.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String selectedFilter = 'Booked';
  DateTime selectedDate = DateTime.now();
  String selectedDateFilter = 'Today';

  Map<String, String> orderButtonStates = {
    '#1524': 'Request Pickup',
    '#1525': 'Testing',
    '#1526': 'Write Review',
    '#1527': 'View Report',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: null,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        bottom: false,
        child: _buildFilterSection(),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink[300]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateFilter = _formatDateFilter(picked);
      });
    }
  }

  String _formatDateFilter(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today';
    } else if (selectedDay == today.subtract(Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showConfirmationPopup(String orderNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TranslatedText(
                  'Confirm Pickup Request',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink[300],
                  ),
                ),
                const SizedBox(height: 12),
                TranslatedText(
                  'Are you sure you want to request pickup for Order $orderNumber?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: TranslatedText(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          orderButtonStates[orderNumber] = 'Pickup Requested';
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const TranslatedText(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.shade50.withOpacity(0.9),
            Colors.pink.shade50.withOpacity(0.5),
            Colors.pink.shade50.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                _buildFilterChip('Booked', selectedFilter == 'Booked'),
                const SizedBox(width: 12),
                _buildFilterChip('Delivered', selectedFilter == 'Delivered'),
                const Spacer(),
                GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TranslatedText(
                          selectedDateFilter,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: selectedFilter == 'Booked'
                    ? _buildBookedOrders()
                    : _buildDeliveredOrders(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink[300] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.pink[300]! : Colors.grey[400]!,
          ),
        ),
        child: TranslatedText(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBookedOrders() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TranslatedText(
                    'Order #1524',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink[400],
                    ),
                  ),
                  TranslatedText(
                    '13/05/2021',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildOrderDetail('Tracking number:', 'IK287368838'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildOrderDetail('Quantity:', '2'),
                  ),
                  Expanded(
                    child: _buildOrderDetail('Subtotal:', '₹2,121.64'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TranslatedText(
                      'ON THE WAY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset('assets/order_loc.gif',scale: 19,)
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
              const SizedBox(width: 8),
              TranslatedText(
                'Showing orders for: $selectedDateFilter',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveredOrders() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
              const SizedBox(width: 8),
              TranslatedText(
                'Showing delivered orders for: $selectedDateFilter',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ),
        _buildDeliveredOrderCard(
          orderNumber: '#1524',
          date: '13/05/2023',
          trackingNumber: 'IK287368838',
          kitId: 'YUJ005',
          quantity: '2',
          subtotal: '₹2,121.64',
          actionText: orderButtonStates['#1524']!,
          actionColor: Colors.pink[300]!,
          onActionTap: () {
            if (orderButtonStates['#1524'] == 'Request Pickup') {
              _showConfirmationPopup('#1524');
            }
          },
        ),
        const SizedBox(height: 16),
        _buildDeliveredOrderCard(
          orderNumber: '#1525',
          date: '12/05/2023',
          trackingNumber: 'IK287368839',
          kitId: 'YUJ006',
          quantity: '1',
          subtotal: '₹1,560.32',
          actionText: orderButtonStates['#1525']!,
          actionColor: Colors.orange,
          hasTestingIcon: true,
        ),
        const SizedBox(height: 16),
        _buildDeliveredOrderCard(
          orderNumber: '#1526',
          date: '11/05/2023',
          trackingNumber: 'IK287368840',
          kitId: 'YUJ007',
          quantity: '3',
          subtotal: '₹3,184.96',
          actionText: orderButtonStates['#1526']!,
          actionColor: Colors.pink[100]!,
          actionTextColor: Colors.pink[300]!,
          onActionTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WriteReviewPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildDeliveredOrderCard(
          orderNumber: '#1527',
          date: '10/05/2023',
          trackingNumber: 'IK287368841',
          kitId: 'YUJ008',
          quantity: '1',
          subtotal: '₹2,121.64',
          actionText: orderButtonStates['#1527']!,
          actionColor: Colors.green[100]!,
          actionTextColor: Colors.green[600]!,
          onActionTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResultsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliveredOrderCard({
    required String orderNumber,
    required String date,
    required String trackingNumber,
    required String kitId,
    required String quantity,
    required String subtotal,
    required String actionText,
    required Color actionColor,
    Color? actionTextColor,
    bool hasTestingIcon = false,
    VoidCallback? onActionTap,
  }) {
    bool showDoubleTick = actionText == 'Pickup Requested';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                'Order $orderNumber',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink[400],
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildOrderDetail('Tracking number:', trackingNumber),
          const SizedBox(height: 4),
          _buildOrderDetail('Kit ID:', kitId),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildOrderDetail('Quantity:', quantity),
              ),
              Expanded(
                child: _buildOrderDetail('Subtotal:', subtotal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const TranslatedText(
                  'DELIVERED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onActionTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: actionColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasTestingIcon) ...[
                        Icon(
                          Icons.science,
                          size: 14,
                          color: actionColor,
                        ),
                        const SizedBox(width: 4),
                      ],
                      TranslatedText(
                        actionText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: actionTextColor ?? actionColor,
                        ),
                      ),
                      if (showDoubleTick) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
                          color: actionColor,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 4),
        TranslatedText(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: label == 'Tracking number:' || label == 'Quantity:' ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }
}

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({super.key});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int selectedRating = 4;
  TextEditingController reviewController = TextEditingController();
  int characterCount = 0;
  final int maxCharacters = 50;

  @override
  void initState() {
    super.initState();
    reviewController.addListener(() {
      setState(() {
        characterCount = reviewController.text.length;
      });
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TranslatedText(
          'Write A Review',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic,
                          color: Colors.pink[300],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        TranslatedText(
                          'Tell us your Voiceprint!',
                          style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.star,
                            size: 32,
                            color: index < selectedRating
                                ? Colors.pink[300]
                                : Colors.grey[300],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  TranslatedText(
                    'Would you like to write anything about the product?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: reviewController,
                      maxLines: null,
                      expands: true,
                      maxLength: maxCharacters,
                      decoration: InputDecoration(
                        hintText: 'Write your review here...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        counterText: '',
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TranslatedText(
                      '$characterCount characters',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (reviewController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: TranslatedText('Please write a review before submitting'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:TranslatedText('Thank you for your review!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                      child: const TranslatedText(
                        'Submit Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}