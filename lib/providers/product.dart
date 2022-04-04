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

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    _setFavorite(!isFavorite);
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.userFavorites)}/$userId/$id.json?auth=$token');
    final response = await http.put(url, body: json.encode(isFavorite));
    if (response.statusCode > 400) {
      _setFavorite(oldStatus);
      throw HttpException('Could not favorite product');
    }
  }
}
