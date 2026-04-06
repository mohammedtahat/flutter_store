// lib/models/cart_item_model.dart
import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

// lib/models/order_model.dart  (combined in same file for simplicity)
class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double total;
  final String address;
  final String paymentMethod;
  final String status;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    this.status = 'قيد المعالجة',
    required this.date,
  });

  static List<OrderModel> dummyOrders = [];
}