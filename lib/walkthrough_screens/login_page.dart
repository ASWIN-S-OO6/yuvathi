import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'otp_verification_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _showError = false;
  bool _showKeyboard = false;
  bool _isLoading = false;
  FocusNode _phoneNumberFocusNode = FocusNode();
  static const String _loginApiUrl = 'https://sgserp.in/erp/api/m_api/';

  @override
  void initState() {
    super.initState();
    _phoneNumberFocusNode.addListener(() {
      setState(() {
        _showKeyboard = _phoneNumberFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied.');
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendOtp() async {
    if (_phoneNumberController.text.length != 10) {
      setState(() => _showError = true);

      return;
    }

    setState(() => _isLoading = true);

    try {
      Position? position = await _getCurrentLocation();
      String latitude = position?.latitude.toString() ?? '0.0';
      String longitude = position?.longitude.toString() ?? '0.0';

      Map<String, String> body = {
        'cid': '21472147',
        'type': '1002',
        'ln': '3433433', // Placeholder for latitude
        'lt': '2323434', // Placeholder for longitude
        'device_id': 'flutter_app_device', // A static device ID placeholder
        'mobile': _phoneNumberController.text, // Use the 10-digit number directly
      };

      print('Sending OTP request with body: $body');

      final response = await http.post(
        Uri.parse(_loginApiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          print('Parsed Response Data: $responseData');

          // Check for success based on error field
          bool isSuccess = false;
          String? message;

          if (responseData is Map<String, dynamic>) {
            bool error = responseData['error'] ?? true; // Default to true if not present
            message = responseData['error_msg']?.toString();
            if (error == false) {
              isSuccess = true;
            }
          }

          if (isSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(phoneNumber: _phoneNumberController.text),
              ),
            );
          } else {
            setState(() => _showError = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message ?? 'Failed to send OTP')),
            );
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          setState(() => _showError = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid response format from server')),
          );
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        setState(() => _showError = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception during OTP sending: $e');
      setState(() => _showError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending OTP. Please check your connection.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleKeyboardInput(String key) {
    if (key == 'Done') {
      _phoneNumberFocusNode.unfocus();
      _sendOtp();
    } else if (key == 'Cancel') {
      _phoneNumberController.clear();
      setState(() => _showError = false);
    } else if (key == '<') {
      if (_phoneNumberController.text.isNotEmpty) {
        _phoneNumberController.text = _phoneNumberController.text
            .substring(0, _phoneNumberController.text.length - 1);
      }
    } else {
      if (_phoneNumberController.text.length < 10) {
        _phoneNumberController.text += key;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pink.shade50.withOpacity(0.9),
                      Colors.pink.shade50.withOpacity(0.3),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/image4.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.39,

                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        'Yuvathi',
                        style: GoogleFonts.abrilFatface(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Text(
                        'Welcome to Yuvathi!',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Partner in Cervical Health',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.shade100.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.pink.shade800,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _phoneNumberFocusNode.requestFocus(),
                                child: TextField(
                                  controller: _phoneNumberController,
                                  focusNode: _phoneNumberFocusNode,
                                  keyboardType: TextInputType.none,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Mobile Number',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            if (_phoneNumberController.text.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey.shade500),
                                onPressed: () {
                                  _phoneNumberController.clear();
                                  setState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                      if (_showError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Please enter a valid 10-digit number',
                                  style: TextStyle(color: Colors.red.shade600),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red.shade600,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _showError = false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Continue with Google clicked!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon/google.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.account_circle, color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy Policy clicked!')),
                          );
                        },
                        child: Text(
                          "Terms & Conditions | Privacy Policy",
                          style: TextStyle(
                            color: Colors.pink.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showKeyboard)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade50,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['1', '2', '3'].map((key) {
                          return _KeyboardButton(
                            buttonKey: key,
                            onPressed: () => _handleKeyboardInput(key),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['4', '5', '6'].map((key) {
                          return _KeyboardButton(
                            buttonKey: key,
                            onPressed: () => _handleKeyboardInput(key),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['7', '8', '9'].map((key) {
                          return _KeyboardButton(
                            buttonKey: key,
                            onPressed: () => _handleKeyboardInput(key),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 61),
                          _KeyboardButton(
                            buttonKey: '0',
                            onPressed: () => _handleKeyboardInput('0'),
                          ),
                          _KeyboardButton(
                            buttonKey: '<',
                            onPressed: () => _handleKeyboardInput('<'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleKeyboardInput('Done'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'DONE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.pink),
              ),
            ),
        ],
      ),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  final String buttonKey;
  final VoidCallback onPressed;

  const _KeyboardButton({
    required this.buttonKey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 72,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          buttonKey,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: buttonKey == '<' || buttonKey == 'Cancel'
                ? Colors.pink.shade600
                : Colors.black,
          ),
        ),
      ),
    );
  }
}