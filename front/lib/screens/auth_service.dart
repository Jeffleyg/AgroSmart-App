import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Para web, use localhost ou seu IP real
  static const String _baseUrl = 'http://localhost:3000/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Future<Map<String, dynamic>> login(String email, String password) async {
  //   try {
  //     final uri = Uri.parse('$_baseUrl/login');
  //     print('Making request to: $uri'); // Debug

  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: json.encode({
  //         'email': email,
  //         'password': password,
  //       }),
  //     ).timeout(const Duration(seconds: 10));

  //     print('Response status: ${response.statusCode}'); // Debug
  //     print('Response body: ${response.body}'); // Debug

  //     final responseData = json.decode(response.body);

  //     if (response.statusCode == 200) {
  //       if (responseData['access_token'] != null) {
  //         await _storage.write(
  //           key: 'access_token',
  //           value: responseData['access_token']
  //         );
  //         await _storage.write(
  //           key: 'user_data',
  //           value: json.encode(responseData['user'])
  //         );
  //         return {'success': true, 'user': responseData['user']};
  //       }
  //       return {'success': false, 'message': 'Token não recebido'};
  //     } else {
  //       return {
  //         'success': false,
  //         'message': responseData['message'] ?? 'Erro no login'
  //       };
  //     }
  //   } catch (e) {
  //     print('Login error: $e'); // Debug
  //     return {'success': false, 'message': 'Erro: ${e.toString()}'};
  //   }
  // }

  Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    // Tratamento unificado de respostas
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData['access_token'] != null) {
        await _storage.write(key: 'access_token', value: responseData['access_token']);
        return {
          'success': true,
          'token': responseData['access_token'],
          'user': responseData['user']
        };
      }
      return {
        'success': false,
        'message': 'Resposta inválida do servidor'
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Erro desconhecido'
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erro de conexão: ${e.toString()}'
    };
  }
}
}