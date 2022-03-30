import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../shared/api.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void _setFavorite(bool newFavorite) {
    isFavorite = newFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    _setFavorite(!isFavorite);
    final url = Uri.parse('${Api.baseUrl}/${Api.getEndpoint(Endpoint.products)}/$id.json');
    final response = await http.patch(url, body: json.encode(this));
    if (response.statusCode > 400) {
      _setFavorite(oldStatus);
      throw HttpException('Could not favorite product');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite
    };
  }
}
