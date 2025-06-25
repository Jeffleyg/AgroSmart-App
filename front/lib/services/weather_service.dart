// services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String baseUrl = 'http://localhost:3000/dashboard'; // Ajuste para seu IP

  final String? authToken;

  WeatherService(this.authToken);

  Future<WeatherData> getCurrentWeather() async {
    final response = await http.get(
      Uri.parse('$baseUrl/clima'),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<List<WeatherForecast>> getWeatherForecast() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dias'),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => WeatherForecast.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }

  Future<Map<String, dynamic>> getDashboardData(String cidade) async {
    final response = await http.get(
      Uri.parse('$baseUrl?cidade=$cidade'),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}