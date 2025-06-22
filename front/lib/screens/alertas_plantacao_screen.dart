import 'package:flutter/material.dart';

class AlertasPlantacaoScreen extends StatelessWidget {
  const AlertasPlantacaoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas de Plantação'),
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
                DropdownMenuItem(value: 'doenca', child: Text('Doença')),
                DropdownMenuItem(value: 'praga', child: Text('Praga')),
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
                      title: const Text('Plantação 2'),
                      subtitle: const Text('Doença tal\n23/06/2026 17:17:41'),
                      leading: const Icon(Icons.warning, color: Colors.red),
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
