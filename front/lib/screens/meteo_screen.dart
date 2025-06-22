import 'package:flutter/material.dart';

class MeteoScreen extends StatelessWidget {
  const MeteoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dados simulados para a previsão do tempo
    final List<WeatherForecast> forecasts = [
      WeatherForecast(day: 'Seg', icon: Icons.wb_sunny, temp: 28),
      WeatherForecast(day: 'Ter', icon: Icons.cloud, temp: 24),
      WeatherForecast(day: 'Qua', icon: Icons.beach_access, temp: 22),
      WeatherForecast(day: 'Qui', icon: Icons.wb_sunny, temp: 30),
      WeatherForecast(day: 'Sex', icon: Icons.thunderstorm, temp: 20),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meteorologia'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Condições atuais
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(177, 237, 179, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange, size: 64),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '28°C Ensolarado',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 128, 0, 1),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Umidade: 65%'),
                        Text('Vento: 10 km/h'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Previsão para os próximos 5 dias
              const Text(
                'Previsão para os próximos 5 dias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    // Usar Wrap para responsividade
                    return Wrap(
                      alignment: WrapAlignment.spaceAround,
                      runSpacing: 16.0,
                      children:
                          forecasts
                              .map(
                                (forecast) => SizedBox(
                                  width:
                                      constraints.maxWidth > 350
                                          ? 60
                                          : constraints.maxWidth / 6,
                                  child: _WeatherDay(forecast: forecast),
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

class _WeatherDay extends StatelessWidget {
  final WeatherForecast forecast;
  const _WeatherDay({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          forecast.day,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Icon(
          forecast.icon,
          size: 36,
          color: const Color.fromRGBO(255, 117, 69, 1),
        ),
        const SizedBox(height: 8),
        Text(
          '${forecast.temp}°C',
          style: const TextStyle(
            color: Color.fromRGBO(0, 128, 0, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Modelo de dados para a previsão
class WeatherForecast {
  final String day;
  final IconData icon;
  final int temp;

  WeatherForecast({required this.day, required this.icon, required this.temp});
}
