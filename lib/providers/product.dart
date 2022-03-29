import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false});

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite
    };
  }
}
