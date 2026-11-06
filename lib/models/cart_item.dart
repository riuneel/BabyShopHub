import 'package:babyshophub/models/product.dart';
class CartItem {
  final ProductData product;
  int quantity;

  
  CartItem({
    required this.product,
    this.quantity = 1,
  });

}