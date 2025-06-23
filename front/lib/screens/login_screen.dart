import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Future<void> _login(BuildContext context) async {
  //   if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Por favor, preencha todos os campos')),
  //     );
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   final result = await _authService.login(
  //     _emailController.text.trim(),
  //     _passwordController.text.trim(),
  //   );

  //   setState(() => _isLoading = false);

  //   if (result['success'] == true) {
  //     Navigator.pushReplacementNamed(context, '/dashboard');
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(result['message'] ?? 'Erro no login')),
  //     );
  //   }
  // }
  Future<void> _login(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha email e senha')));
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Falha no login')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                screenHeight, // força o conteúdo a ocupar pelo menos toda a altura
          ),
          child: Align(
            alignment:
                Alignment.center, // alinha o container exatamente no centro
            child: Container(
              width: 360, // largura fixa como o exemplo
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/logo.png', height: 80),
                  const SizedBox(height: 24),
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Divider(color: Colors.grey.shade400),
                  const SizedBox(height: 24),

                  const Text('Seu e-mail'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'contato@exemplo.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Sua senha'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '••••••',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _login(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Color.fromARGB(255, 7, 155, 99),
                              )
                              : const Text('Entrar'),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Ainda não tem conta?'),
                      TextButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/register'),
                        child: const Text('Cadastre-se'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
