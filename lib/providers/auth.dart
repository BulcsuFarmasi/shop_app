import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../shared/api.dart';
import '../shared/secret.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;

  Future<void> _authenticate(String email, String password, AuthEndpoint endpoint) async {
    final url = Uri.parse('${Api.authUrl}:${Api.getAuthEndpoint(endpoint)}?key=$firebaseApiKey');
    print(url.toString());
    try {
      final response =
          await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, AuthEndpoint.signUp);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, AuthEndpoint.signIn);
  }

  void logOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
