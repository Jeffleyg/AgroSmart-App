// screens/meteo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../providers/auth_provider.dart';
import '../models/weather_model.dart';

class MeteoScreen extends StatefulWidget {
  const MeteoScreen({Key? key}) : super(key: key);

  @override
  _MeteoScreenState createState() => _MeteoScreenState();
}

class _MeteoScreenState extends State<MeteoScreen> {
  late WeatherService _weatherService;
  WeatherData? _currentWeather;
  List<WeatherForecast> _forecasts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _weatherService = WeatherService(authProvider.token);
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final current = await _weatherService.getCurrentWeather();
      final forecasts = await _weatherService.getWeatherForecast();
      
      setState(() {
        _currentWeather = current;
        _forecasts = forecasts.take(5).toList(); // Pegar apenas 5 dias
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('sol') || condition.toLowerCase().contains('clear')) {
      return Icons.wb_sunny;
    } else if (condition.toLowerCase().contains('nuvem') || condition.toLowerCase().contains('cloud')) {
      return Icons.cloud;
    } else if (condition.toLowerCase().contains('chuva') || condition.toLowerCase().contains('rain')) {
      return Icons.beach_access;
    } else if (condition.toLowerCase().contains('trovoada') || condition.toLowerCase().contains('thunder')) {
      return Icons.thunderstorm;
    } else {
      return Icons.wb_cloudy;
    }
  }

  String _getDayName(String date) {
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final dateTime = DateTime.parse(date);
    return days[dateTime.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meteorologia'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeatherData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Condições atuais
                        if (_currentWeather != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(177, 237, 179, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                if (_currentWeather!.icon.isNotEmpty)
                                  Image.network(
                                    'http://openweathermap.org/img/wn/${_currentWeather!.icon}@2x.png',
                                    width: 64,
                                    height: 64,
                                  )
                                else
                                  const Icon(Icons.wb_sunny,
                                      color: Colors.orange, size: 64),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_currentWeather!.temperatura.toStringAsFixed(1)}°C ${_currentWeather!.condicao}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 128, 0, 1),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        'Umidade: ${_currentWeather!.umidade.toStringAsFixed(0)}%'),
                                    const Text('Vento: 10 km/h'), // Dado mockado
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                        // Previsão para os próximos dias
                        const Text(
                          'Previsão para os próximos dias',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(0, 128, 0, 1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Wrap(
                                alignment: WrapAlignment.spaceAround,
                                runSpacing: 16.0,
                                children: _forecasts
                                    .map(
                                      (forecast) => SizedBox(
                                        width: constraints.maxWidth > 350
                                            ? 60
                                            : constraints.maxWidth / 6,
                                        child: Column(
                                          children: [
                                            Text(
                                              _getDayName(forecast.data),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Icon(
                                              _getWeatherIcon(forecast.condicao),
                                              size: 36,
                                              color: const Color.fromRGBO(
                                                  255, 117, 69, 1),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${forecast.temperaturaMax.toStringAsFixed(0)}°C',
                                              style: const TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 128, 0, 1),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}