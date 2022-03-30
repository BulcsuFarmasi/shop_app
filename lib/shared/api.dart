

class Api {
  static const String baseUrl = 'https://shop-app-c7564-default-rtdb.europe-west1.firebasedatabase.app';

  static Map<Endpoint, String> _endPoints = {
    Endpoint.products: 'products',
    Endpoint.orders: 'orders',
  };

  static String getEndpoint(Endpoint endpoint) => _endPoints[endpoint] ?? "";
}

enum Endpoint { products, orders }
