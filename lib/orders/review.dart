import 'package:flutter/material.dart';

import '../service/translated_text.dart';

class WriteReviewPage extends StatefulWidget {
  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int selectedRating = 4; // Default to 4 stars as shown in image
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Write A Review',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Review card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Voice print icon and text
                  Container(
                    padding: EdgeInsets.all(16),
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
                        SizedBox(width: 8),
                        Text(
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
                  SizedBox(height: 24),

                  // Star rating
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
                          padding: EdgeInsets.all(4),
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
                  SizedBox(height: 24),

                  // Review text
                  Text(
                    'Would you like to write anything about the product?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),

                  // Text input area
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
                        contentPadding: EdgeInsets.all(12),
                        counterText: '', // Hide default counter
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Character counter
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$characterCount characters',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Submit button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit review
                  _submitReview();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    if (reviewController.text.trim().isEmpty) {
      // Show message if no review text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TranslatedText('Please write a review before submitting'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:TranslatedText('Thank you for your review!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or handle submission
    Navigator.pop(context);
  }
}