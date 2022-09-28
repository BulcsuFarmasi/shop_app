import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/shared/api.dart';
import 'product.dart';

class Products with ChangeNotifier {
  Products(this.authToken, this.userId);

  String? authToken;
  String? userId;

  List<Product> _items = [];

  Product findById(String id) => _items.firstWhere((Product item) => item.id == id);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => items.where((Product product) => product.isFavorite).toList();

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final favorites = await fetchFavorites();
      final List<Product> loadedProducts = [];
      extractedData.forEach((String id, dynamic product) {
        loadedProducts.add(Product(
            id: id,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            isFavorite: favorites[id] ?? false,
            imageUrl: product['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> fetchFavorites() async {
    try {
      final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.userFavorites)}/$userId.json?auth=$authToken');
      final favoritesResponse = await http.get(url);
      return json.decode(favoritesResponse.body);
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'creatorId': userId
          }));

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
      final url =
          Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}/${updateProduct.id}.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': updateProduct.title,
            'description': updateProduct.description,
            'imageUrl': updateProduct.imageUrl,
            'price': updateProduct.price
          }));
      _items[productIndex] = updateProduct;
    } else {
      throw StateError('Product can\'t be found');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('${Api.dbUrl}/${Api.getDbEndpoint(DbEndpoint.products)}/$id.json?auth=$authToken');
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

  void updateUser(String? newToken, String? newUserId) {
    authToken = newToken;
    userId = newUserId;
  }
}
