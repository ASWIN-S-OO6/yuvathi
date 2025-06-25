// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:yuvathi/screens/payment_success.dart';
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({Key? key}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String selectedPaymentMethod = '';
//   bool showUpiSelection = false;
//   String selectedUpiApp = '';
//   int _transactionCounter = 0; // For generating unique transaction IDs
//
//   // Generate a unique transaction ID (e.g., Yu001, Yu002, etc.)
//   String _generateTransactionId() {
//     _transactionCounter++;
//     return 'Yu${_transactionCounter.toString().padLeft(3, '0')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => _showCancelDialog(),
//         ),
//         title: const Text(
//           'Payment',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => _showCancelDialog(),
//             child: const Text(
//               'CANCEL',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Main Content
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // UPI Section
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         // UPI Header
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 'assets/icon/upi.png',
//                                 width: 40,
//                                 height: 40,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.orange[100],
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: const Icon(
//                                       Icons.payment,
//                                       color: Colors.orange,
//                                       size: 24,
//                                     ),
//                                   );
//                                 },
//                               ),
//                               const SizedBox(width: 12),
//                               const Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Pay By Any UPI App',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Google Pay, Phone Pay, Paytm And More',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Radio<String>(
//                                 value: 'upi',
//                                 groupValue: selectedPaymentMethod,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedPaymentMethod = value!;
//                                     showUpiSelection = true;
//                                   });
//                                 },
//                                 activeColor: Theme.of(context).primaryColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Credit & Debit Cards Section
//                   const Text(
//                     'CREDIT & DEBIT CARDS',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // Saved Card
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         const Expanded(
//                           child: Text(
//                             'XXXXXXXXXXXX4242',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                         Radio<String>(
//                           value: 'card_4242',
//                           groupValue: selectedPaymentMethod,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedPaymentMethod = value!;
//                               showUpiSelection = false;
//                             });
//                           },
//                           activeColor: Theme.of(context).primaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // Add New Card
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Theme.of(context).primaryColor,
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.add,
//                           color: Theme.of(context).primaryColor,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           'Add A New Credit or Debit Card',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 100), // Space for button
//                 ],
//               ),
//             ),
//           ),
//
//           // Proceed To Pay Button
//           Positioned(
//             bottom: 16,
//             left: 16,
//             right: 16,
//             child: SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: selectedPaymentMethod.isNotEmpty
//                     ? () {
//                   if (selectedPaymentMethod == 'upi' && selectedUpiApp.isEmpty) {
//                     setState(() {
//                       showUpiSelection = true;
//                     });
//                   } else {
//                     _processPayment();
//                   }
//                 }
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Proceed To Pay',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // UPI Selection Popup
//           if (showUpiSelection)
//             Material(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     margin: const EdgeInsets.all(16),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'Select UPI :',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               _buildUpiOption(
//                                 'Google Pay',
//                                 '9686',
//                                 'assets/icon/gpay.png',
//                                 'googlepay',
//                               ),
//                               const SizedBox(height: 8),
//                               _buildUpiOption(
//                                 'PayPal',
//                                 '9686',
//                                 'assets/icon/paypal.png',
//                                 'paypal',
//                               ),
//                               const SizedBox(height: 8),
//                               _buildUpiOption(
//                                 'Apple Pay',
//                                 '9686',
//                                 'assets/icon/applepay.png',
//                                 'applepay',
//                               ),
//                               const SizedBox(height: 16),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 48,
//                                 child: ElevatedButton(
//                                   onPressed: selectedUpiApp.isNotEmpty
//                                       ? () {
//                                     setState(() {
//                                       showUpiSelection = false;
//                                     });
//                                     _processPayment();
//                                   }
//                                       : null,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Theme.of(context).primaryColor,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                     ),
//                                     elevation: 0,
//                                   ),
//                                   child: const Text(
//                                     'Continue',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUpiOption(String name, String number, String imagePath, String value) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedUpiApp = value;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: selectedUpiApp == value
//                 ? Theme.of(context).primaryColor
//                 : Colors.grey[300]!,
//             width: selectedUpiApp == value ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               imagePath,
//               width: 32,
//               height: 32,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Icon(
//                     Icons.payment,
//                     color: Colors.grey,
//                     size: 20,
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     number,
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: 18,
//               height: 18,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: selectedUpiApp == value
//                       ? const Color(0xFFE91E63)
//                       : Colors.grey[400]!,
//                   width: 2,
//                 ),
//               ),
//               child: selectedUpiApp == value
//                   ? Center(
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFFE91E63),
//                   ),
//                 ),
//               )
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCancelDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.warning_outlined,
//                     color: Theme.of(context).primaryColor,
//                     size: 30,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Are you sure you want to cancel the payment?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).primaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: const Text(
//                           'No',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           Navigator.of(context).pop();
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Theme.of(context).primaryColor),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           'Yes',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _showPaymentConfirmationDialog({
//     required double amount,
//     required String upiId,
//     required String merchantName,
//     required String transactionId,
//     required String currency,
//   }) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.payment,
//                     color: Theme.of(context).primaryColor,
//                     size: 30,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Confirm Payment',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Amount: $currency $amount',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Paying to: $merchantName',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'UPI ID: $upiId',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Transaction ID: $transactionId',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Theme.of(context).primaryColor),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           _launchUpiPayment(
//                             amount: amount,
//                             upiId: upiId,
//                             merchantName: merchantName,
//                             transactionId: transactionId,
//                             currency: currency,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).primaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: const Text(
//                           'Confirm',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _showQrCodeDialog({
//     required String paymentUrl,
//   }) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Scan to Pay',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () async {
//                     // On tap, launch the UPI intent URL (same as scanning the QR code)
//                     try {
//                       final Uri uri = Uri.parse(paymentUrl);
//                       if (await canLaunchUrl(uri)) {
//                         await launchUrl(uri, mode: LaunchMode.externalApplication);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: TranslatedTranslatedTranslatedTranslatedText('Could not launch $selectedUpiApp. Please ensure it is installed.'),
//                           ),
//                         );
//                       }
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: TranslatedTranslatedTranslatedTranslatedText('Error launching $selectedUpiApp: $e'),
//                         ),
//                       );
//                     }
//                   },
//                   child: QrImageView(
//                     data: paymentUrl,
//                     version: QrVersions.auto,
//                     size: 200.0,
//                     backgroundColor: Colors.white,
//                     padding: const EdgeInsets.all(10),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Scan the QR code with any UPI app to complete the payment.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       // Navigate to PaymentSuccessPage
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const PaymentSuccessPage(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       'Continue',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _launchUpiPayment({
//     required double amount,
//     required String upiId,
//     required String merchantName,
//     required String transactionId,
//     required String currency,
//   }) async {
//     // Properly encode the parameters to avoid issues with special characters
//     final encodedUpiId = Uri.encodeComponent(upiId);
//     final encodedMerchantName = Uri.encodeComponent(merchantName);
//     final encodedAmount = amount.toString();
//     final encodedCurrency = Uri.encodeComponent(currency);
//     final encodedTransactionId = Uri.encodeComponent(transactionId);
//     final encodedTransactionNote = Uri.encodeComponent('Payment for $transactionId');
//
//     // Construct UPI intent URL with properly encoded parameters
//     final paymentUrl = 'upi://pay?pa=$encodedUpiId&pn=$encodedMerchantName&am=$encodedAmount&cu=$encodedCurrency'
//         '&tn=$encodedTransactionNote&tr=$encodedTransactionId';
//
//     try {
//       final Uri uri = Uri.parse(paymentUrl);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//         // Show QR code dialog before navigating to PaymentSuccessPage
//         await _showQrCodeDialog(paymentUrl: paymentUrl);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Could not launch $selectedUpiApp. Please ensure it is installed.'),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error launching $selectedUpiApp: $e'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _processPayment() async {
//     // Replace these with your actual account details
//     const double amount = 100.00;
//     const String currency = 'INR';
//     const String merchantUpiId = 'aswin.s200506@okaxis'; // Replace with your actual UPI ID (e.g., yourname@bank)
//     const String merchantName = 'YOUR_MERCHANT_NAME'; // Replace with your actual name or business name
//     const String merchantEmail = 'YOUR_EMAIL'; // Replace with your actual email for PayPal
//
//     if (selectedPaymentMethod == 'upi') {
//       if (selectedUpiApp == 'googlepay') {
//         // Generate a unique transaction ID
//         final transactionId = _generateTransactionId();
//
//         // Show payment confirmation dialog
//         await _showPaymentConfirmationDialog(
//           amount: amount,
//           upiId: merchantUpiId,
//           merchantName: merchantName,
//           transactionId: transactionId,
//           currency: currency,
//         );
//       } else if (selectedUpiApp == 'paypal') {
//         // Construct PayPal URL
//         final paymentUrl =
//             'https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=$merchantEmail&amount=$amount&currency_code=$currency';
//         try {
//           final Uri uri = Uri.parse(paymentUrl);
//           if (await canLaunchUrl(uri)) {
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const PaymentSuccessPage(),
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: TranslatedTranslatedText('Could not launch PayPal. Please ensure it is installed.'),
//               ),
//             );
//           }
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: TranslatedTranslatedText('Error launching PayPal: $e'),
//             ),
//           );
//         }
//       } else if (selectedUpiApp == 'applepay') {
//         // Apple Pay placeholder
//         const paymentUrl = 'https://www.apple.com/apple-pay/';
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: TranslatedTranslatedText('Apple Pay requires in-app integration. This is a placeholder redirect.'),
//           ),
//         );
//         try {
//           final Uri uri = Uri.parse(paymentUrl);
//           if (await canLaunchUrl(uri)) {
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const PaymentSuccessPage(),
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: TranslatedTranslatedText('Could not launch Apple Pay.'),
//               ),
//             );
//           }
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: TranslatedTranslatedText('Error launching Apple Pay: $e'),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: TranslatedTranslatedText('Please select a valid payment app.'),
//           ),
//         );
//       }
//     } else if (selectedPaymentMethod == 'card_4242') {
//       print('Processing payment with saved card: $selectedPaymentMethod');
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const PaymentSuccessPage(),
//         ),
//       );
//     } else {
//       print('Processing payment with: $selectedPaymentMethod');
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => const PaymentSuccessPage(),
//         ),
//       );
//     }
//   }
// }