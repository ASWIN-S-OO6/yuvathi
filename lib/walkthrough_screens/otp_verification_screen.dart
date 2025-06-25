import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'otp_verified.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 27;
  late Timer _timer;
  late final String _displayPhoneNumber;
  bool _showError = false;
  bool _showKeyboard = false;
  bool _isLoading = false;
  static const String _verifyOtpApiUrl = 'https://sgserp.in/erp/api/m_api/';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _displayPhoneNumber = '+91 ${widget.phoneNumber.substring(0, 5)} ${widget.phoneNumber.substring(5)}';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
      setState(() {
        _showKeyboard = true;
      });
    });

    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {
          _showKeyboard = _focusNodes.any((node) => node.hasFocus);
        });
      });
    }
  }

  void _startResendTimer() {
    _resendTimer = 27;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
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

  Future<void> _verifyOtp() async {
    final otp = _getOtp();
    if (otp.length != 6) {
      setState(() => _showError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Position? position = await _getCurrentLocation();
      String latitude = position?.latitude.toString() ?? '0.0';
      String longitude = position?.longitude.toString() ?? '0.0';

      Map<String, String> body = {
        'cid': '21472147',
        'type': '1003',
        'ln': '322334', // Latitude
        'lt': '233432', // Longitude
        'device_id': '122334',
        'mobile': widget.phoneNumber,
        'otp': otp,
      };

      print('Verifying OTP with body: $body');

      final response = await http.post(
        Uri.parse(_verifyOtpApiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          print('Parsed Response Data: $responseData');

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
            _timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OtpVerifiedScreen()),
            );
          } else {
            setState(() => _showError = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message ?? 'Invalid OTP')),
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
      print('Exception during OTP verification: $e');
      setState(() => _showError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error verifying OTP. Please check your connection.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
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
        'mobile': widget.phoneNumber, // Use the 10-digit number directly
      };

      print('Resending OTP with body: $body');

      final response = await http.post(
        Uri.parse(_verifyOtpApiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('Resend OTP API Response Status Code: ${response.statusCode}');
      print('Resend OTP API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Resend OTP Parsed Response Data: $responseData');

        bool isSuccess = false;
        String? message;

        if (responseData is Map<String, dynamic>) {
          bool error = responseData['error'] ?? true;
          message = responseData['error_msg']?.toString();
          if (error == false) {
            isSuccess = true;
          }
        }

        if (isSuccess) {
          _startResendTimer();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP resent successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message ?? 'Failed to resend OTP')),
          );
        }
      } else {
        throw Exception('Failed to resend OTP');
      }
    } catch (e) {
      print('Exception during OTP resending: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error resending OTP. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleKeyboardInput(String key) {
    if (key == 'Done') {
      for (var node in _focusNodes) {
        node.unfocus();
      }
      _verifyOtp();
    } else if (key == 'Cancel') {
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      setState(() => _showError = false);
    } else if (key == '<') {
      int currentFocusedIndex = _focusNodes.indexWhere((node) => node.hasFocus);
      int indexToClear = -1;

      if (currentFocusedIndex != -1) {
        if (_otpControllers[currentFocusedIndex].text.isNotEmpty) {
          indexToClear = currentFocusedIndex;
        } else if (currentFocusedIndex > 0) {
          indexToClear = currentFocusedIndex - 1;
        }
      } else {
        for (int i = _otpControllers.length - 1; i >= 0; i--) {
          if (_otpControllers[i].text.isNotEmpty) {
            indexToClear = i;
            break;
          }
        }
      }

      if (indexToClear != -1) {
        _otpControllers[indexToClear].clear();
        _focusNodes[indexToClear].requestFocus();
      }
    } else {
      int firstEmptyIndex = _otpControllers.indexWhere((c) => c.text.isEmpty);
      if (firstEmptyIndex != -1) {
        _otpControllers[firstEmptyIndex].text = key;
        if (firstEmptyIndex < 5) {
          _focusNodes[firstEmptyIndex + 1].requestFocus();
        } else {
          _focusNodes[firstEmptyIndex].unfocus();
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
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
                        Colors.white.withOpacity(0.7),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.4, 0.8, 1.0],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/otp.svg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'OTP Illustration\nPlaceholder',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          );
                        },
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
                          'OTP Verification',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We've sent a verification code to",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _displayPhoneNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 45,
                              height: 55,
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.none,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else {
                                      _focusNodes[index].unfocus();
                                    }
                                  } else if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                  setState(() {});
                                },
                                onTap: () {
                                  _otpControllers[index].selection = TextSelection.fromPosition(
                                    TextPosition(offset: _otpControllers[index].text.length),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
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
                                    'Invalid OTP',
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
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _resendTimer == 0 && !_isLoading ? _resendOtp : null,
                          child: Text(
                            _resendTimer == 0 ? 'Resend OTP' : 'Resend OTP in $_resendTimer s',
                            style: TextStyle(
                              color: _resendTimer == 0 && !_isLoading ? Colors.pinkAccent : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOtp,
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
                              'VERIFY OTP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                if (_showKeyboard)
                  Container(
                    padding: const EdgeInsets.all(10),
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