import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(177, 237, 179, 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Olá, Teresa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              color: Color.fromRGBO(0, 128, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.notifications_none,
                        color: Color.fromRGBO(0, 128, 0, 1),
                        size: 28,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Logo/folhas
                Center(
                  child: Image.asset('assets/images/logo.png', height: 40),
                ),
                const SizedBox(height: 16),
                // Previsão do tempo
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(0, 128, 0, 1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _WeatherDay(icon: Icons.cloud, label: 'Segunda'),
                      _WeatherDay(icon: Icons.wb_sunny, label: 'Terça'),
                      _WeatherDay(icon: Icons.beach_access, label: 'Quarta'),
                      _WeatherDay(icon: Icons.wb_sunny, label: 'Quinta'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Placeholder para gráfico/metas
                Container(
                  height: 50,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                // Alertas
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 177, 69, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alertas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 128, 0, 1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _AlertInfo(title: 'Plantação', value: '5'),
                          _AlertInfo(title: 'Sol', value: '2'),
                          _AlertInfo(title: 'Plantação', value: '0'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Gráfico e porcentagens
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(177, 237, 179, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        'Irrigação: 50%\nAlertas: 30%\nRegistro: 20%',
                        style: TextStyle(color: Color.fromRGBO(0, 128, 0, 1)),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 300,
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, 1),
                                  FlSpot(2, 4),
                                  FlSpot(3, 2),
                                  FlSpot(4, 5),
                                ],
                                isCurved: true,
                                color: Colors.blue,
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(0, 128, 0, 1),
        unselectedItemColor: Color.fromRGBO(76, 175, 80, 1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat_auto),
            label: 'Meteo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            label: 'Registro',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Serviços',
          ),
        ],
      ),
    );
  }
}

class _WeatherDay extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WeatherDay({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36, color: const Color.fromRGBO(255, 117, 69, 1)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color.fromRGBO(177, 237, 177, 1)),
        ),
      ],
    );
  }
}

class _AlertInfo extends StatelessWidget {
  final String title;
  final String value;
  const _AlertInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.green)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
