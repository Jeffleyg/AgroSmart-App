import 'package:flutter/material.dart';

class AlertasIrrigacaoScreen extends StatelessWidget {
  const AlertasIrrigacaoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dados simulados de alertas de irrigação
    final List<IrrigationAlert> alerts = [
      IrrigationAlert(
        plantation: 'Plantação 1 (Milho)',
        recommendation: 'Irrigar por 30 minutos',
        reason: 'Umidade do solo baixa (25%)',
        date: '24/07/2024 08:00',
        icon: Icons.water_drop,
        color: Colors.blue,
      ),
      IrrigationAlert(
        plantation: 'Plantação 3 (Soja)',
        recommendation: 'Suspender irrigação por 24h',
        reason: 'Umidade do solo alta (85%) devido à chuva',
        date: '23/07/2024 15:30',
        icon: Icons.cloudy_snowing,
        color: Colors.red,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações de Irrigação'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de recomendação',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'todas', child: Text('Todas')),
                      DropdownMenuItem(
                        value: 'irrigar',
                        child: Text('Necessário Irrigar'),
                      ),
                      DropdownMenuItem(
                        value: 'suspender',
                        child: Text('Suspender Irrigação'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Plantação',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'todas', child: Text('Todas')),
                      DropdownMenuItem(value: 'p1', child: Text('Plantação 1')),
                      DropdownMenuItem(value: 'p2', child: Text('Plantação 2')),
                      DropdownMenuItem(value: 'p3', child: Text('Plantação 3')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  alerts.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhuma recomendação de irrigação no momento.',
                        ),
                      )
                      : ListView.builder(
                        itemCount: alerts.length,
                        itemBuilder: (context, index) {
                          final alert = alerts[index];
                          return _HoverableCard(
                            borderColor: alert.color,
                            child: ListTile(
                              leading: Icon(
                                alert.icon,
                                color: alert.color,
                                size: 40,
                              ),
                              title: Text(
                                alert.recommendation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${alert.plantation}\n${alert.reason}\n${alert.date}',
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableCard extends StatefulWidget {
  final Widget child;
  final Color borderColor;

  const _HoverableCard({required this.child, required this.borderColor});

  @override
  _HoverableCardState createState() => _HoverableCardState();
}

class _HoverableCardState extends State<_HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Card(
        elevation: _isHovered ? 8 : 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: widget.borderColor,
            width: _isHovered ? 2.5 : 1.5,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

// Modelo de dados para os alertas
class IrrigationAlert {
  final String plantation;
  final String recommendation;
  final String reason;
  final String date;
  final IconData icon;
  final Color color;

  IrrigationAlert({
    required this.plantation,
    required this.recommendation,
    required this.reason,
    required this.date,
    required this.icon,
    required this.color,
  });
}
