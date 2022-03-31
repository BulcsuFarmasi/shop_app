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

  Future<void> _authenticate(String email, String password, AuthEndpoint endpoint) async {
    final url = Uri.parse('${Api.authUrl}:${Api.getAuthEndpoint(endpoint)}?key=$firebaseApiKey');
    print(url.toString());
    try {
      final response =
      await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
      final responseBody = json.decode(response.body);
      if(responseBody['error'] != null) {
          throw HttpException(responseBody['error']['message']);
      };

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
}
