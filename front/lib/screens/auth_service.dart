import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'http://localhost:3000'; // Para emulador Android
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  
  // Adicione esta variável para manter o estado em memória
  String? _token;
  Map<String, dynamic>? _userData;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['access_token'];
        _userData = data['user'] ?? {'email': email};
        
        // Armazena token e dados do usuário
        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(key: 'user_data', value: json.encode(_userData));
        
        return {'success': true, 'token': _token, 'user': _userData};
      } else {
        return {'success': false, 'message': 'Erro no login'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> initialize() async {
    // Carrega o token ao iniciar o app
    _token = await _storage.read(key: 'auth_token');
    final userDataString = await _storage.read(key: 'user_data');
    if (userDataString != null) {
      _userData = json.decode(userDataString);
    }
  }

  Future<String?> getToken() async {
    _token ??= await _storage.read(key: 'auth_token');
    return _token;
  }

  Future<bool> isLoggedIn() async {
    return await getToken() != null;
  }

  Future<void> logout() async {
    _token = null;
    _userData = null;
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }

  String? get userEmail => _userData?['email'];
  String? get userName => _userData?['name'] ?? 'Usuário';
}