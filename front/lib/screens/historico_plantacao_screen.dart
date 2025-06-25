import 'package:agrosmart_login/screens/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HistoricoPlantacaoScreen extends StatefulWidget {
  const HistoricoPlantacaoScreen({Key? key}) : super(key: key);

  @override
  _HistoricoPlantacaoScreenState createState() => _HistoricoPlantacaoScreenState();
}

class _HistoricoPlantacaoScreenState extends State<HistoricoPlantacaoScreen> {
  String? _selectedFilter;
  DateTime? _periodoInicial;
  DateTime? _periodoFinal;
  List<dynamic> _historico = [];
  bool _loading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _obterToken();
    _carregarHistorico();
  }

  void _obterToken() async {
    // Implemente a obtenção do token JWT (ex: SecureStorage)

    _token = await AuthService().getToken();
  }

  Future<void> _carregarHistorico() async {
    setState(() => _loading = true);
    
    try {
      final url = Uri.parse('http://localhost:3000/plantacoes/historico');
      final response = await http.get(
        url.replace(queryParameters: _buildFilters()),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() => _historico = json.decode(response.body));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar histórico: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Map<String, String> _buildFilters() {
    final filters = <String, String>{};
    
    if (_selectedFilter != null) {
      filters['tipoMonitoramento'] = _selectedFilter!;
    }
    
    if (_periodoInicial != null) {
      filters['periodoInicial'] = _periodoInicial!.toIso8601String();
    }
    
    if (_periodoFinal != null) {
      filters['periodoFinal'] = _periodoFinal!.toIso8601String();
    }
    
    return filters;
  }

  Future<void> _selecionarData(BuildContext context, bool isInicial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        if (isInicial) {
          _periodoInicial = picked;
        } else {
          _periodoFinal = picked;
        }
      });
      _carregarHistorico();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Plantação'),
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
            DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Tipo de monitoramento',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'doenca', child: Text('Doença')),
                DropdownMenuItem(value: 'praga', child: Text('Praga')),
              ],
              onChanged: (value) {
                setState(() => _selectedFilter = value);
                _carregarHistorico();
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selecionarData(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Período inicial',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _periodoInicial != null
                            ? DateFormat('dd/MM/yyyy').format(_periodoInicial!)
                            : 'Selecione uma data',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _selecionarData(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Período final',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _periodoFinal != null
                            ? DateFormat('dd/MM/yyyy').format(_periodoFinal!)
                            : 'Selecione uma data',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _historico.length,
                  itemBuilder: (context, index) {
                    final plantacao = _historico[index];
                    final monitoramentos = plantacao['monitoramentos'] as List;
                    
                    if (monitoramentos.isEmpty) {
                      return _HoverableCard(
                        child: ListTile(
                          title: Text(plantacao['nome']),
                          subtitle: Text('Nenhum monitoramento registrado'),
                        ),
                      );
                    }
                    
                    return Column(
                      children: monitoramentos.map<Widget>((monitor) {
                        return _HoverableCard(
                          child: ListTile(
                            title: Text(plantacao['nome']),
                            subtitle: Text(
                              '${monitor['estadoPlantas']}\n'
                              '${DateFormat('dd/MM/yyyy HH:mm').format(
                                DateTime.parse(monitor['dataHora']).toLocal()
                              )}',
                            ),
                            leading: Icon(
                              monitor['status'] == 'success'
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: monitor['status'] == 'success'
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                        );
                      }).toList(),
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