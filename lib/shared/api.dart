class Api {
  static const String dbUrl =
      'https://shop-app-c7564-default-rtdb.europe-west1.firebasedatabase.app';
  static const String authUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts';

  static Map<DbEndpoint, String> _dbEndPoints = {
    DbEndpoint.products: 'products',
    DbEndpoint.orders: 'orders',
    DbEndpoint.userFavorites: 'userFavorites',
  };

  static Map<AuthEndpoint, String> _authEndPoints = {
    AuthEndpoint.signUp: 'signUp',
    AuthEndpoint.signIn: 'signInWithPassword',
  };

  static String getDbEndpoint(DbEndpoint endpoint) =>
      _dbEndPoints[endpoint] ?? "";

  static String getAuthEndpoint(AuthEndpoint endpoint) =>
      _authEndPoints[endpoint] ?? "";
}

enum DbEndpoint {
  products,
  orders,
  userFavorites,
}

enum AuthEndpoint {
  signUp,
  signIn,
}
