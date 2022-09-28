import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() => {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'quantity': quantity,
      };
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get allProductCount => _items.values
      .fold(0, (int sum, CartItem currentItem) => sum += currentItem.quantity);

  double get totalAmount {
    return _items.values.fold(
        0, (double sum, item) => sum + item.product.price * item.quantity);
  }

  void addItem(Product product) {
    _items.update(
      product.id!,
      (CartItem item) => CartItem(
        product: item.product,
        quantity: item.quantity + 1,
      ),
      ifAbsent: () => CartItem(
        product: product,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeQuantityFromItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (oldCartItem) => CartItem(
            product: oldCartItem.product, quantity: oldCartItem.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
