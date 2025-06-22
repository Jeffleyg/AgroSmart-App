import 'package:flutter/material.dart';

class HistoricoPlantacaoScreen extends StatelessWidget {
  const HistoricoPlantacaoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Plantação'),
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
                labelText: 'Tipo de monitoramento',
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
                  _HoverableCard(
                    child: ListTile(
                      title: const Text('Plantação 2'),
                      subtitle: const Text('Sei lá\n23/04/2024 14:17:41'),
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  _HoverableCard(
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

class _HoverableCard extends StatefulWidget {
  final Widget child;

  const _HoverableCard({required this.child});

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
        elevation: _isHovered ? 8 : 1,
        color: _isHovered ? Colors.grey.shade50 : null,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: widget.child,
      ),
    );
  }
}
