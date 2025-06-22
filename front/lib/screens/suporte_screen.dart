import 'package:flutter/material.dart';

class SuporteScreen extends StatelessWidget {
  const SuporteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda e Suporte'),
        backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Perguntas Frequentes (FAQ)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color.fromRGBO(0, 128, 0, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const _FaqItem(
            question: 'Como faço para registrar uma nova plantação?',
            answer:
                'Vá para a tela inicial, clique no ícone "Serviços" no menu inferior e preencha o formulário de cadastro de plantação.',
          ),
          const _FaqItem(
            question: 'Os dados de monitoramento são salvos automaticamente?',
            answer:
                'Não, você precisa clicar no botão "Salvar dados" na tela de monitoramento para registrar as informações.',
          ),
          const _FaqItem(
            question: 'As recomendações de irrigação são em tempo real?',
            answer:
                'As recomendações são baseadas nos últimos dados de umidade do solo e na previsão do tempo. Certifique-se de registrar os dados com frequência para obter recomendações mais precisas.',
          ),
          const Divider(height: 40, thickness: 1),
          Text(
            'Entre em Contato',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color.fromRGBO(0, 128, 0, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.email, color: Colors.green),
            title: Text('E-mail'),
            subtitle: Text('suporte@agrosmart.com'),
          ),
          const ListTile(
            leading: Icon(Icons.phone, color: Colors.green),
            title: Text('Telefone'),
            subtitle: Text('(11) 4002-8922'),
          ),
          const ListTile(
            leading: Icon(Icons.chat_bubble, color: Colors.green),
            title: Text('Chat ao vivo'),
            subtitle: Text('Disponível de Seg. a Sex. das 9h às 18h'),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
