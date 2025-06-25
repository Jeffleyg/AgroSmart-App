// lib/screens/cadastro_plantacao_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';

class CadastroPlantacaoScreen extends StatefulWidget {
  const CadastroPlantacaoScreen({Key? key}) : super(key: key);

  @override
  _CadastroPlantacaoScreenState createState() => _CadastroPlantacaoScreenState();
}

class _CadastroPlantacaoScreenState extends State<CadastroPlantacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _tipoCulturaController = TextEditingController();
  final TextEditingController _dataInicioPlantioController = TextEditingController();
  final TextEditingController _dataPrevisaoColheitaController = TextEditingController();
  final TextEditingController _dataPlantioController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Para emulador Android use '10.0.2.2', para dispositivo físico use seu IP local
  static const String SERVER_IP = '10.0.2.2';

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // Future<void> _cadastrarPlantacao() async {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);

  //     // Verificação EXTRA do token
  //     print('Token no cadastro: ${authProvider.token}');
  //     final prefs = await SharedPreferences.getInstance();
  //     print('Token no SharedPreferences: ${prefs.getString('auth_token')}');

  //     if (authProvider.token == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Sessão expirada. Faça login novamente')),
  //       );
  //       Navigator.pushReplacementNamed(context, '/login');
  //       return;
  //     }

  //     try {
  //       final response = await http.post(
  //         Uri.parse('http://localhost:3000/plantacoes'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer ${authProvider.token}',
  //         },
  //         body: json.encode({
  //           // ... seus dados
  //         }),
  //       );
  //       print('Resposta do servidor: ${response.statusCode} - ${response.body}');
  //     } catch (e) {
  //       print('Erro na requisição: $e');
  //     }
  //   }
  Future<void> _cadastrarPlantacao() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  
  // Verificação do token
  print('Token no cadastro: ${authProvider.token}');
  final prefs = await SharedPreferences.getInstance();
  print('Token no SharedPreferences: ${prefs.getString('auth_token')}');

  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    // Formatação correta das datas para ISO 8601 (ex: "2023-01-01")
    final dataInicio = _dataInicioPlantioController.text;
    final dataPrevisao = _dataPrevisaoColheitaController.text;
    final dataPlantio = _dataPlantioController.text;

    // Verificação das datas
    if (dataInicio.isEmpty || dataPrevisao.isEmpty || dataPlantio.isEmpty) {
      throw Exception('Preencha todas as datas');
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/plantacoes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.token}',
      },
      body: json.encode({
        'nome': _nomeController.text,
        'codigoPlantacao': _codigoController.text,
        'tipoCultura': _tipoCulturaController.text,
        'dataInicioPlantio': dataInicio,
        'dataPrevisaoColheita': dataPrevisao,
        'dataPlantio': dataPlantio,
      }),
    );

    print('Resposta do servidor: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 201) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plantação cadastrada com sucesso!')),
        );
        Navigator.pop(context);
      }
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Erro no cadastro');
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    _tipoCulturaController.dispose();
    _dataInicioPlantioController.dispose();
    _dataPrevisaoColheitaController.dispose();
    _dataPlantioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Plantação'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome da plantação';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código plantação',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o código da plantação';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tipoCulturaController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de cultura',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tipo de cultura';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dataInicioPlantioController,
                  decoration: InputDecoration(
                    labelText: 'Data Início Plantio',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _dataInicioPlantioController.text = 
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        }
                      },
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione a data';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dataPrevisaoColheitaController,
                  decoration: InputDecoration(
                    labelText: 'Data prevista para colheita',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, _dataPrevisaoColheitaController),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione a data prevista';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dataPlantioController,
                  decoration: InputDecoration(
                    labelText: 'Data do plantio',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, _dataPlantioController),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione a data do plantio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading ? null : _cadastrarPlantacao,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Salvar', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}