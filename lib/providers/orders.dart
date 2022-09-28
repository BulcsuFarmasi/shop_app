import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';

import './cart.dart';
import '../shared/api.dart';

class Order {
  final String? id;
  final double amount;
  final List<CartItem> items;
  final DateTime date;

  Order({
    required this.id,
    required this.amount,
    required this.items,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  Orders(this.authToken, this.userId, this._items);

  List<Order> _items = [];

  final String? authToken;
  final String? userId;

  List<Order> get items {
    return [..._items];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    notifyListeners();
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.orders)}/$userId/.json?auth=$authToken');
    final currentDate = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'amount': total,
              'products': cartProducts,
              'date': currentDate.toIso8601String(),
            },
          ));
      String orderId = json.decode(response.body)['name'];
      _items.insert(0, Order(id: orderId, amount: total, items: cartProducts, date: currentDate));
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.orders)}/$userId/.json?auth=$authToken');
    final response = await http.get(url);
    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<Order> loadedOrders = [];
      extractedData.forEach((id, order) {
        final List<CartItem> products = [];
        order['products'].forEach((product) => {
              products.add(CartItem(
                product: Product(
                    id: product['id'], title: product['title'], price: product['price'], description: '', imageUrl: ''),
                quantity: product['quantity'],
              ))
            });

        loadedOrders.add(Order(
          id: id,
          amount: order['amount'],
          items: products,
          date: DateTime.parse(order['date']),
        ));
      });
      _items = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
