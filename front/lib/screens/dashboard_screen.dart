import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'auth_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
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
                            'Olá Seja Bem-vindo(a)',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              color: Color.fromRGBO(0, 128, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            color: Color.fromRGBO(0, 128, 0, 1),
                            size: 28,
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            color: const Color.fromRGBO(0, 128, 0, 1),
                            onPressed: () async {
                              await authService.logout();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            },
                          ),
                        ],
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
                // Placeholder para gráfico/metas e Alertas em um layout responsivo
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Se a tela for larga (web/tablet), usar uma linha
                    if (constraints.maxWidth > 600) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildAlertsCard(context)),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: _buildChartCard()),
                        ],
                      );
                    }
                    // Se for estreita (mobile), usar uma coluna
                    return Column(
                      children: [
                        _buildAlertsCard(context),
                        const SizedBox(height: 16),
                        _buildChartCard(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(0, 128, 0, 1),
        unselectedItemColor: Color.fromRGBO(76, 175, 80, 1),
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/meteo');
              break;
            case 2:
              Navigator.pushNamed(context, '/monitoramento-plantacao');
              break;
            case 3:
              Navigator.pushNamed(context, '/perfil');
              break;
            case 4:
              Navigator.pushNamed(context, '/cadastro-plantacao');
              break;
          }
        },
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

  // Widget para o card de Alertas
  Widget _buildAlertsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/alertas/plantacao');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 177, 69, 1),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAlertInfo(
                  context,
                  title: 'Plantação',
                  value: '5',
                  route: '/alertas/plantacao',
                ),
                _buildAlertInfo(
                  context,
                  title: 'Sol',
                  value: '2',
                  route: '/alertas/sol',
                ),
                _buildAlertInfo(
                  context,
                  title: 'Irrigação',
                  value: '2',
                  route: '/alertas/irrigacao',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para o card do Gráfico
  Widget _buildChartCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(177, 237, 179, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Irrigação: 50%\nAlertas: 30%\nRegistro: 20%',
            style: TextStyle(color: Color.fromRGBO(0, 128, 0, 1)),
          ),
          const SizedBox(width: 8), // Adicionado para espaçamento
          Expanded(
            child: SizedBox(
              height: 150, // Altura ajustada
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(2, 4),
                        FlSpot(3, 2),
                        FlSpot(4, 5),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cada item de alerta
  Widget _buildAlertInfo(
    BuildContext context, {
    required String title,
    required String value,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: _AlertInfo(title: title, value: value),
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

class _AlertInfo extends StatefulWidget {
  final String title;
  final String value;
  const _AlertInfo({required this.title, required this.value});

  @override
  State<_AlertInfo> createState() => _AlertInfoState();
}

class _AlertInfoState extends State<_AlertInfo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isHovered ? 1.1 : 1.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(scale),
        transformAlignment: Alignment.center,
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
