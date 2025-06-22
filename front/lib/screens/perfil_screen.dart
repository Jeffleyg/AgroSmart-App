import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Color.fromRGBO(0, 128, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do usuário
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(177, 237, 179, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações Pessoais',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 128, 0, 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Nome: Teresa'),
                  const Text('E-mail: teresa@email.com'),
                  const Text('Telefone: (11) 99999-9999'),
                  const Text('Localização: São Paulo, SP'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Configurações
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(177, 237, 179, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configurações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 128, 0, 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notificações'),
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Idioma'),
                    trailing: const Text('Português'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Alterar Senha'),
                    onTap: () {},
                  ),
                  const Divider(),
                  _HoverableListTile(
                    leading: const Icon(Icons.help_outline, color: Colors.blue),
                    title: const Text('Ajuda e Suporte'),
                    onTap: () {
                      Navigator.pushNamed(context, '/suporte');
                    },
                  ),
                  _HoverableListTile(
                    leading: const Icon(Icons.feedback, color: Colors.orange),
                    title: const Text('Enviar Feedback'),
                    onTap: () {
                      Navigator.pushNamed(context, '/feedback');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Botão de logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Text('Sair'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableListTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final VoidCallback onTap;

  const _HoverableListTile({
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  _HoverableListTileState createState() => _HoverableListTileState();
}

class _HoverableListTileState extends State<_HoverableListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ListTile(
        tileColor: _isHovered ? Colors.green.withOpacity(0.1) : null,
        leading: widget.leading,
        title: widget.title,
        onTap: widget.onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
