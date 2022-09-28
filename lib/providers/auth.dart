import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/auth_exception.dart';
import '../shared/api.dart';
import '../shared/secret.dart';

class Auth with ChangeNotifier {

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  late Timer _authTimer;

  bool get isAuth {
    return _expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null;
  }

  String? get token => _token;

  String? get userId => _userId;

  Future<void> _authenticate(String email, String password, AuthEndpoint endpoint) async {
    final url = Uri.parse('${Api.authUrl}:${Api.getAuthEndpoint(endpoint)}?key=$firebaseApiKey');
    try {
      final response =
          await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw AuthException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId,  'expiryDate':  _expiryDate!.toIso8601String()});
      await prefs.setString('userData', userData);


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

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData') ?? "") as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);


    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    _autoLogOut();
    notifyListeners();



    return true;
  }

  void logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
