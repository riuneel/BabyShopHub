import 'package:babyshophub/models/cart_item.dart';
import 'package:babyshophub/models/product.dart';
import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems =>
      List.unmodifiable(_cartItems); // read-only view of cartItems

  bool addToCart(ProductData product) {
    if (product.productStock <= 0) {
      return false;
    }

    final matchingItems = _cartItems.where(
      (item) => item.product.productId == product.productId,
    );

    if (matchingItems.isNotEmpty) {
      final existingItem = matchingItems.first;
      if (existingItem.quantity < product.productStock) {
        existingItem.quantity++;
        notifyListeners();
        return true;
      }
    } else {
      _cartItems.add(CartItem(product: product));
      notifyListeners();
      return true;
    }

    return false;
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.productId == productId);
    notifyListeners();
  }

  bool updateQuantity(int productId, int newQuantity) {
    final matchingItems = _cartItems.where(
      (item) => item.product.productId == productId,
    );
    if (matchingItems.isEmpty) {
      return false;
    }
    final item = matchingItems.first;
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return true;
    }
    if (newQuantity > item.product.productStock) {
      return false;
    }
    if (newQuantity == item.quantity) {
      return true;
    }
    item.quantity = newQuantity;
    notifyListeners();
    return true;
  }

  double getTotalPrice() {
    double total = 0;
    for (int x = 0; x < _cartItems.length; x++) {
      double subtotal =
          _cartItems[x].product.productPrice * _cartItems[x].quantity;
      total = total + subtotal;
    }
    return total;
  }

  int getTotalItems() {
    int totalItems = 0;
    for (int x = 0; x < _cartItems.length; x++) {
      totalItems = totalItems + _cartItems[x].quantity;
    }
    return totalItems;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
