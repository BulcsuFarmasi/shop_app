import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../shared/api.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  Product findById(String id) => _items.firstWhere((Product item) => item.id == id);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => items.where((Product product) => product.isFavorite).toList();

  Future<void> addProduct(Product newProduct) {
    final url = Uri.parse('${Api.baseUrl}/${Api.getEndpoint(Endpoint.products)}');
    return http
        .post(url,
            body: json.encode(newProduct))
        .then((response) {
      final addedProduct = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price);
      _items.add(addedProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProduct(Product updateProduct) {
    final productIndex = _items.indexWhere((Product product) => product.id == updateProduct.id);
    if (productIndex >= 0) {
      _items[productIndex] = updateProduct;
    } else {
      throw StateError('Product can\'t be found');
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((Product product) => product.id == id);
    notifyListeners();
  }
}
