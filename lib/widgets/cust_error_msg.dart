import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorMessage extends StatefulWidget {
  final String message;
  final VoidCallback onClose;

  const CustomErrorMessage({
    super.key,
    required this.message,
    required this.onClose,
  });

  @override
  State<CustomErrorMessage> createState() => _CustomErrorMessageState();
}

class _CustomErrorMessageState extends State<CustomErrorMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade200,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.close_sharp, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          InkWell(
            onTap: widget.onClose,
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}