import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../shared/api.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  Product findById(String id) => _items.firstWhere((Product item) => item.id == id);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => items.where((Product product) => product.isFavorite).toList();

  Future<void> fetchProducts() async {
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}.json');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    final List<Product> loadedProducts = [];
    extractedData.forEach((String id, dynamic product) {
      loadedProducts.add(Product(
          id: id,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          isFavorite: product['isFavorite'],
          imageUrl: product['imageUrl']));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}.json');
    try {
      final response = await http.post(url, body: json.encode(newProduct));

      final addedProduct = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price);
      _items.add(addedProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product updateProduct) async {
    final productIndex = _items.indexWhere((Product product) => product.id == updateProduct.id);
    if (productIndex >= 0) {
      final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}/${updateProduct.id}.json');
      await http.patch(url, body: json.encode(updateProduct));
      _items[productIndex] = updateProduct;
    } else {
      throw StateError('Product can\'t be found');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}/$id.json');
    final existingProductIndex = _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode > 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete program');
    }
    existingProduct = null;
  }
}
