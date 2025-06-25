class DashboardData {
  final WeatherData climaAtual;
  final List<WeatherForecast> previsao;
  final Alertas alertas;
  final List<HistoricoClima> historico;
  final AnaliseClima analise;

  DashboardData({
    required this.climaAtual,
    required this.previsao,
    required this.alertas,
    required this.historico,
    required this.analise,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      climaAtual: WeatherData.fromJson(json['climaAtual']),
      previsao: (json['previsao'] as List)
          .map((item) => WeatherForecast.fromJson(item))
          .toList(),
      alertas: Alertas.fromJson(json['alertas']),
      historico: (json['historico'] as List)
          .map((item) => HistoricoClima.fromJson(item))
          .toList(),
      analise: AnaliseClima.fromJson(json['analise']),
    );
  }
}

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

class Alertas {
  final int total;
  final List<String> mensagens;

  Alertas({
    required this.total,
    required this.mensagens,
  });

  factory Alertas.fromJson(Map<String, dynamic> json) {
    return Alertas(
      total: json['total'] ?? 0,
      mensagens: (json['mensagens'] as List).cast<String>(),
    );
  }
}

class HistoricoClima {
  final String data;
  final double tempMin;
  final double tempMax;
  final double chuva;
  final String condicao;

  HistoricoClima({
    required this.data,
    required this.tempMin,
    required this.tempMax,
    required this.chuva,
    required this.condicao,
  });

  factory HistoricoClima.fromJson(Map<String, dynamic> json) {
    return HistoricoClima(
      data: json['data'] ?? '',
      tempMin: json['tempMin']?.toDouble() ?? 0.0,
      tempMax: json['tempMax']?.toDouble() ?? 0.0,
      chuva: json['chuva']?.toDouble() ?? 0.0,
      condicao: json['condicao'] ?? '',
    );
  }
}

class AnaliseClima {
  final String risco;
  final String recomendacao;

  AnaliseClima({
    required this.risco,
    required this.recomendacao,
  });

  factory AnaliseClima.fromJson(Map<String, dynamic> json) {
    return AnaliseClima(
      risco: json['risco'] ?? '',
      recomendacao: json['recomendacao'] ?? '',
    );
  }
}