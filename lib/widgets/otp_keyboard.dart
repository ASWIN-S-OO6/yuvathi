import 'package:flutter/material.dart';

class CustomNumericKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final String cancelText;

  const CustomNumericKeyboard({
    super.key,
    required this.onKeyPressed,
    this.cancelText = 'Cancel', // Default text for cancel button
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color of the keyboard area
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Reduced padding
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyButton('1', 'ABC'),
              _buildKeyButton('2', 'DEF'),
              _buildKeyButton('3', 'GHI'),
            ],
          ),
          const SizedBox(height: 8), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyButton('4', 'JKL'),
              _buildKeyButton('5', 'MNO'),
              _buildKeyButton('6', 'PQR'),
            ],
          ),
          const SizedBox(height: 8), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyButton('7', 'STU'),
              _buildKeyButton('8', 'VWX'),
              _buildKeyButton('9', 'YZ'),
            ],
          ),
          const SizedBox(height: 8), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlKeyButton(cancelText, () => onKeyPressed(cancelText)),
              _buildKeyButton('0', ''),
              _buildControlKeyButton('<', () => onKeyPressed('<')), // Backspace icon
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => onKeyPressed('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 5,
                  shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String number, String letters) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Slightly reduced padding
        child: InkWell(
          onTap: () => onKeyPressed(number),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.pink.shade100, // Splash effect on tap
          highlightColor: Colors.pink.shade50, // Highlight effect on tap
          child: Container(
            height: 55, // Slightly reduced height for keys
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87), // Slightly smaller font
                  ),
                  if (letters.isNotEmpty)
                    Text(
                      letters,
                      style: TextStyle(fontSize: 9, color: Colors.grey[600]), // Slightly smaller font
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlKeyButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Slightly reduced padding
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.pink.shade100,
          highlightColor: Colors.pink.shade50,
          child: Container(
            height: 55, // Slightly reduced height for keys
            decoration: BoxDecoration(
              color: text == 'Cancel' || text == 'Clear' ? Colors.pink.shade50 : Colors.grey[100], // Pink tint for Cancel/Clear
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: text == '<'
                  ? const Icon(Icons.backspace_outlined, size: 24, color: Colors.black87)
                  : Text(
                text,
                style: TextStyle(
                  fontSize: 16, // Slightly smaller font
                  fontWeight: FontWeight.bold,
                  color: text == 'Cancel' || text == 'Clear' ? Colors.redAccent.shade700 : Colors.black87, // Pink color for text
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}