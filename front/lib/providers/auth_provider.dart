// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  static const String _tokenKey = 'auth_token';

  String? get token => _token;

  Future<void> login(String token) async {
    _token = token;
    await _saveToken(token);
    notifyListeners();
    print('Token definido: $_token'); // Debug
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('Token salvo no SharedPreferences: ${prefs.getString(_tokenKey)}'); // Debug
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    print('Token recuperado: $_token'); // Debug
    return _token != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _token = null;
    notifyListeners();
  }
}