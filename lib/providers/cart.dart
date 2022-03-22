import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id, required this.title, required this.quantity, required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get allProductCount => _items.values.fold(0, (int sum, CartItem currentItem) => sum += currentItem.quantity);

  double get totalAmount {
    return _items.values.fold(0, (double sum, item) => sum + item.price * item.quantity);
  }

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

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
