import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuvathi/screens/checkout_billing_screen.dart';

import '../components/cart_manager.dart';

class CartPage2 extends StatelessWidget {
  const CartPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontScale = screenWidth / 360;

    final imageWidth = screenWidth * 0.37;
    final imageHeight = screenHeight * 0.28;
    final buttonHeight = screenHeight * 0.05;

    return Consumer<CartManager>(
      builder: (context, cartManager, child) {
        // Debug print to confirm cart items
        print('CartPage2 build - Cart items: ${cartManager.cartItems.length}');
        cartManager.cartItems.forEach((item) {
          print('Item: ${item.title}, Quantity: ${item.quantity}');
        });

        // Calculate total number of products (sum of quantities)
        int totalProducts = cartManager.cartItems.fold(0, (sum, item) => sum + item.quantity);

        return Container(
          color: Colors.grey[100],
          child: cartManager.cartItems.isEmpty
              ? Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 16 * fontScale, color: Colors.grey),
            ),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 6 * fontScale),
                  itemCount: cartManager?.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartManager.cartItems[index];
                    return Container(
                      height: imageHeight,
                      margin: EdgeInsets.symmetric(horizontal: 8 * fontScale, vertical: 6 * fontScale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12 * fontScale),
                        border: Border.all(
                          color: Colors.pinkAccent,
                          width: 1.0 * fontScale,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8 * fontScale,
                            spreadRadius: 1.5 * fontScale,
                            offset: Offset(0, 4 * fontScale),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12 * fontScale),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: imageWidth,
                              height: imageHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10 * fontScale),
                                  bottomLeft: Radius.circular(10 * fontScale),
                                ),
                                color: Colors.grey,
                              ),
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      'Product Image\nPlaceholder',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12 * fontScale),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12 * fontScale),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 14 * fontScale,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6 * fontScale),
                                    Row(
                                      children: [
                                        Text(
                                          '₹${item.price.toInt()}',
                                          style: TextStyle(
                                            fontSize: 14 * fontScale,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                        SizedBox(width: 6 * fontScale),
                                        Expanded(
                                          child: Text(
                                            'MRP ₹${item.originalPrice.toInt()}',
                                            style: TextStyle(
                                              fontSize: 12 * fontScale,
                                              color: Colors.grey[600],
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 6 * fontScale),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4 * fontScale, vertical: 1 * fontScale),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(4 * fontScale),
                                          ),
                                          child: Text(
                                            '${item.discountPercentage.toInt()}% OFF',
                                            style: TextStyle(
                                              fontSize: 10 * fontScale,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6 * fontScale),
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 14 * fontScale),
                                        SizedBox(width: 3 * fontScale),
                                        Text(
                                          '${item.rating}',
                                          style: TextStyle(color: Colors.grey[700], fontSize: 12 * fontScale),
                                        ),
                                        SizedBox(width: 3 * fontScale),
                                        Text(
                                          '(${item.reviewCount})',
                                          style: TextStyle(color: Colors.grey[500], fontSize: 12 * fontScale),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8 * fontScale),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(6 * fontScale),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  cartManager?.updateQuantity(index, item.quantity - 1);
                                                },
                                                icon: Icon(Icons.remove, size: 16 * fontScale),
                                                constraints: BoxConstraints(
                                                    minWidth: 32 * fontScale, minHeight: 32 * fontScale),
                                                padding: EdgeInsets.zero,
                                              ),
                                              Text(
                                                '${item.quantity}',
                                                style: TextStyle(fontSize: 14 * fontScale),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  cartManager.updateQuantity(index, item.quantity + 1);
                                                },
                                                icon: Icon(Icons.add, size: 16 * fontScale),
                                                constraints: BoxConstraints(
                                                    minWidth: 32 * fontScale, minHeight: 32 * fontScale),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            cartManager?.removeFromCart(index);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red.shade700,
                                            size: 20 * fontScale,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(
                                              minWidth: 32 * fontScale, minHeight: 32 * fontScale),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8 * fontScale),
                                    SizedBox(
                                      width: double.infinity,
                                      height: buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const CheckoutBillingScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.pinkAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8 * fontScale),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 8 * fontScale),
                                        ),
                                        child: Text(
                                          'Buy',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14 * fontScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}