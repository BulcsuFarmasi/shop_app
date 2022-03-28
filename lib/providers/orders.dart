import 'package:flutter/material.dart';
import './cart.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> cartProducts, double total) {

      _items.insert(
        0,
        Order(
          id: DateTime.now().toString(),
          amount: total,
          products: cartProducts,
          date: DateTime.now(),
        ));
    notifyListeners();
  }
}
