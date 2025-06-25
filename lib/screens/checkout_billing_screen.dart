import 'package:flutter/material.dart';
import 'package:yuvathi/components/MyTextField.dart';
import 'package:yuvathi/screens/order_summary.dart';

import '../service/translated_text.dart';
import '../widgets/responsive_layout.dart';

class CheckoutBillingScreen extends StatefulWidget {
  final String? phoneNumber; // Parameter to receive logged-in phone number

  const CheckoutBillingScreen({super.key, this.phoneNumber});

  @override
  _CheckoutBillingScreenState createState() => _CheckoutBillingScreenState();
}

class _CheckoutBillingScreenState extends State<CheckoutBillingScreen> {
  // Separate controllers for each field
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prefill phone number with logged-in number if available
    if (widget.phoneNumber != null && widget.phoneNumber!.length == 10) {
      _phoneController.text = widget.phoneNumber!;
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetAddressController.dispose();
    _apartmentController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  // Simulate auto-detect location by pre-filling fields
  void _autoDetectLocation() {
    setState(() {
      _streetAddressController.text = '123, Main Road';
      _cityController.text = 'Chennai';
      _stateController.text = 'Tamil Nadu';
      _postalCodeController.text = '600001';
      _landmarkController.text = 'Near Central Station';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: TranslatedText('Location auto-detected (simulated)')),
    );
  }

  // Basic validation before proceeding
  bool _validateFields() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _streetAddressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _postalCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TranslatedText('Please fill all required fields')),
      );
      return false;
    }
    // Basic email validation
    if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TranslatedText('Please enter a valid email address')),
      );
      return false;
    }
    // Basic phone validation (10 digits)
    if (_phoneController.text.length != 10 || int.tryParse(_phoneController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TranslatedText('Please enter a valid 10-digit phone number')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //
    final double fontScale = (screenWidth / 360.0).clamp(0.8, 1.5);
    // // A general responsive factor that can be used for padding, margins, etc.
    // Clamped to prevent excessive scaling on larger screens (like tablets)
    final double responsiveFactor = (screenWidth / 400.0).clamp(0.8, 1.5);
    final isTablet = ResponsiveLayout.isTablet(context);
    // final titleFontSize = isTablet ? 24.0 * fontScale : 18.0 * fontScale;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const TranslatedText(
          'Checkout',
          style: TextStyle(color: Colors.white,),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: TranslatedText(
                  "Billing Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // First Name
              MyTextField(
                label: 'First Name',
                hintText: 'Enter your first name',
                isRequired: true,
                controller: _firstNameController,
              ),
              const SizedBox(height: 10),
              // Last Name
              MyTextField(
                label: 'Last Name',
                hintText: 'Enter your last name',
                isRequired: true,
                controller: _lastNameController,
              ),
              const SizedBox(height: 10),
              // Phone
              MyTextField(
                label: 'Phone',
                hintText: 'Enter your mobile number',
                isRequired: true,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              // Email
              MyTextField(
                label: 'Email address',
                hintText: 'Enter your email address',
                isRequired: true,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Country/Region
              Row(
                children: [
                  const TranslatedText(
                    "Country/Region",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  TranslatedText(
                    "India",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Auto Detect Location
              TextButton(
                onPressed: _autoDetectLocation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 5),
                    TranslatedText(
                      "Auto Detect Location",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Street Address
              MyTextField(
                label: 'Street address',
                hintText: 'House no and street name',
                isRequired: true,
                controller: _streetAddressController,
              ),
              const SizedBox(height: 10),
              // Apartment (Optional)
              MyTextField(
                label: 'Apartment (optional)',
                hintText: 'Apartment, suite, unit, etc.',
                isRequired: false,
                controller: _apartmentController,
              ),
              const SizedBox(height: 10),
              // Landmark (Optional)
              MyTextField(
                label: 'Landmark (optional)',
                hintText: 'e.g., Near Central Park',
                isRequired: false,
                controller: _landmarkController,
              ),
              const SizedBox(height: 10),
              // Town/City
              MyTextField(
                label: 'Town / City',
                hintText: 'Enter your town or city',
                isRequired: true,
                controller: _cityController,
              ),
              const SizedBox(height: 10),
              // State/Country
              MyTextField(
                label: 'State / Country',
                hintText: 'Enter your state',
                isRequired: true,
                controller: _stateController,
              ),
              const SizedBox(height: 10),
              // Postal/Zip
              MyTextField(
                label: 'Postal / Zip',
                hintText: 'Enter your postal code',
                isRequired: true,
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Please Note Disclaimer
              Container(
                margin: const EdgeInsets.only(top: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TranslatedText('Please Note: '),
                    Expanded(
                      child: TranslatedText(
                        "Collection of used kit will be done from the address mentioned in the Shipping Address only.",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              // Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateFields()) {
                        // Construct the full address
                        String fullAddress = _streetAddressController.text;
                        if (_apartmentController.text.isNotEmpty) {
                          fullAddress += '\n${_apartmentController.text}';
                        }
                        fullAddress += '\n${_cityController.text}, ${_stateController.text} ${_postalCodeController.text}';
                        if (_landmarkController.text.isNotEmpty) {
                          fullAddress += '\nLandmark: ${_landmarkController.text}';
                        }
                        // Navigate to OrderSummaryPage with the address and phone number
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderSummaryPage(
                              customerName: '${_firstNameController.text} ${_lastNameController.text}',
                              address: fullAddress,
                              phoneNumber: _phoneController.text, // Pass the phone number
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const TranslatedText('Continue'),
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