// models/weather_model.dart
class WeatherData {
  final double temperatura;
  final String condicao;
  final double umidade;
  final String icon;

  WeatherData({
    required this.temperatura,
    required this.condicao,
    required this.umidade,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperatura: json['temperatura']?.toDouble() ?? 0.0,
      condicao: json['condicao'] ?? '',
      umidade: json['umidade']?.toDouble() ?? 0.0,
      icon: json['icon'] ?? '',
    );
  }
}

class WeatherForecast {
  final String data;
  final double temperaturaMin;
  final double temperaturaMax;
  final String condicao;
  final double chuva;

  WeatherForecast({
    required this.data,
    required this.temperaturaMin,
    required this.temperaturaMax,
    required this.condicao,
    required this.chuva,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      data: json['data'] ?? '',
      temperaturaMin: json['temperaturaMin']?.toDouble() ?? 0.0,
      temperaturaMax: json['temperaturaMax']?.toDouble() ?? 0.0,
      condicao: json['condicao'] ?? '',
      chuva: json['chuva']?.toDouble() ?? 0.0,
    );
  }
}