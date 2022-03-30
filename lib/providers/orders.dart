import 'package:flutter/material.dart';
import './cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared/api.dart';

class Order {
  final String? id;
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

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    notifyListeners();
    final url = Uri.parse('${Api.baseUrl}/${Api.getEndpoint(Endpoint.orders)}.json');
    final currentDate = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'amount': total,
              'products': cartProducts,
              'date': currentDate.toString(),
            },
          ));
      String orderId = json.decode(response.body)['name'];
      _items.insert(0, Order(id: orderId, amount: total, products: cartProducts, date: currentDate));
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('${Api.baseUrl}/${Api.getEndpoint(Endpoint.orders)}.json');
    final response = await http.get(url);
    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Order> loadedOrders = [];
      extractedData.forEach((id, order) {
        final List<CartItem> products = [];
        order['products'].forEach((product) => {
              products.add(CartItem(
                id: product['id'],
                title: product['title'],
                quantity: product['quantity'],
                price: product['price'],
              ))
            });
        loadedOrders.add(Order(
          id: id,
          amount: order['amount'],
          products: products,
          date: DateTime.parse(order['date']),
        ));
      });
      _items = loadedOrders;
      print(_items);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
