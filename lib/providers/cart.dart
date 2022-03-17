import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id, required this.title, required this.quantity, required this.price});
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  void addItem(String productId, double price, String title) {
    _items.update(
      productId,
      (CartItem item) => CartItem(
        id: item.id,
        title: item.title,
        quantity: item.quantity + 1,
        price: item.price,
      ),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        quantity: 1,
        price: price,
      ),
    );
    notifyListeners();
  }
}
