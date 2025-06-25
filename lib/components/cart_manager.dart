import 'package:flutter/foundation.dart';

class CartItem {
  final String title;
  final String imagePath;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final double rating;
  final int reviewCount;
  int quantity;

  CartItem({
    required this.title,
    required this.imagePath,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.quantity,
  });
}

class CartManager with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  void addToCart(CartItem item) {
    final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.title == item.title);
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index].quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}