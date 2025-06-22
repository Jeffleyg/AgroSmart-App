import 'package:flutter/material.dart';

class AlertasSolScreen extends StatelessWidget {
  const AlertasSolScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas do Sol'),
        backgroundColor: Color.fromRGBO(0, 128, 0, 1),
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipo de alerta',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'seca', child: Text('Sol muito seco')),
                DropdownMenuItem(
                  value: 'umido',
                  child: Text('Sol muito úmido'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Período inicial',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Período final',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Plantação 1'),
                      subtitle: const Text(
                        'Sol muito seco\nTemperatura 48°C sem vento\n23/06/2026 17:17:41',
                      ),
                      leading: const Icon(Icons.wb_sunny, color: Colors.orange),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Plantação 1'),
                      subtitle: const Text(
                        'Sol muito úmido\nTemperatura 10°C sem vento\n23/06/2026 17:17:41',
                      ),
                      leading: const Icon(Icons.wb_cloudy, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
