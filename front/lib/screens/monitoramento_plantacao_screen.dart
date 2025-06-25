import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MonitoramentoPlantacaoScreen extends StatefulWidget {
  const MonitoramentoPlantacaoScreen({Key? key}) : super(key: key);

  @override
  _MonitoramentoPlantacaoScreenState createState() =>
      _MonitoramentoPlantacaoScreenState();
}

class _MonitoramentoPlantacaoScreenState
    extends State<MonitoramentoPlantacaoScreen> {
  final _umidadeController = TextEditingController();
  final _estadoController = TextEditingController(text: 'Saudável');
  final _plantacaoController = TextEditingController();
  List<dynamic> _historico = [];
  List<dynamic> _plantacoes = [];
  String? _selectedPlantacaoId;
  String? _token; // Armazene o token JWT aqui

  @override
  void initState() {
    super.initState();
    // Carregar plantações ao iniciar
    _carregarPlantacoes();
    // Carregar histórico
    _carregarHistorico();
    // Obter o token (você precisa implementar isso)
    _obterToken();
  }

  void _obterToken() async {
    // Implemente a lógica para obter o token JWT armazenado
    // Exemplo: _token = await SecureStorage().getToken();
    _token = 'SEU_TOKEN_JWT_AQUI'; // Substitua pelo token real
  }

  Future<void> _carregarPlantacoes() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/plantacoes'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            _plantacoes = data;
            _selectedPlantacaoId = _plantacoes[0]['id'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhuma plantação cadastrada')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar plantações: $e')),
      );
    }
  }
  Future<void> _carregarHistorico() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/monitoramento/historico'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _historico = json.decode(response.body);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar histórico: $e')),
      );
    }
  }

  Future<void> _salvarDados() async {
    if (_selectedPlantacaoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma plantação')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/monitoramento'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'umidadeSolo': double.parse(_umidadeController.text),
          'estadoPlantas': _estadoController.text,
          'plantacaoId': _selectedPlantacaoId,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados salvos com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _limparDados();
        _carregarHistorico(); // Atualiza o histórico após salvar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $e')),
      );
    }
  }

  void _limparDados() {
    _umidadeController.clear();
    _estadoController.text = 'Saudável';
    setState(() {});
  }

  @override
  void dispose() {
    _umidadeController.dispose();
    _estadoController.dispose();
    _plantacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento da Plantação'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: const Color.fromRGBO(229, 245, 229, 1),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 40),
                    const SizedBox(width: 10),
                    const Text(
                      'AGROSMART',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 100, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Monitoramento da Plantação',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedPlantacaoId,
                            decoration: const InputDecoration(
                              labelText: 'Selecione uma plantação',
                              border: OutlineInputBorder(),
                            ),
                            items: _plantacoes.map<DropdownMenuItem<String>>((plantacao) {
                              return DropdownMenuItem<String>(
                                value: plantacao['id'],
                                child: Text(plantacao['nome'] ?? 'Sem nome'),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPlantacaoId = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Selecione uma plantação';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Umidade Do Solo(%)',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _umidadeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Digite a umidade do solo',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Estados das Plantas',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _estadoController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _salvarDados,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Salvar dados',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _limparDados,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Limpar dados',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/historico-plantacao');
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Histórico Registros',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Data/Hora',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Umidade(%)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Estado Plantas',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ..._historico.map((monitoramento) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(
                                      DateTime.parse(monitoramento['dataHora']),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    monitoramento['umidadeSolo'].toString(),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    monitoramento['estadoPlantas'],
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}