import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'responsive_layout.dart';

class ResponsiveTextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isMobileNumber;
  final int? maxLength;
  final TextInputType keyboardType;

  const ResponsiveTextInput({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
    this.isMobileNumber = false,
    this.maxLength,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveLayout.getResponsivePadding(context);
    final fontSize = ResponsiveLayout.getResponsiveFontSize(context, 16.0);

    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: fontSize),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: padding.left,
            vertical: padding.top,
          ),
        ),
        inputFormatters: isMobileNumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : null,
        validator: isMobileNumber
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a mobile number';
                }
                if (value.length < 10) {
                  return 'Mobile number must be 10 digits';
                }
                return null;
              }
            : validator,
      ),
    );
  }
}
