import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/alertas_plantacao_screen.dart';
import 'screens/alertas_sol_screen.dart';
import 'screens/alertas_irrigacao_screen.dart';
import 'screens/historico_plantacao_screen.dart';
import 'screens/cadastro_plantacao_screen.dart';
import 'screens/meteo_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/monitoramento_plantacao_screen.dart';
import 'screens/suporte_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/tutorial_screen.dart';
import 'screens/auth_wrapper.dart';

void main() {
  runApp(const AgroSmartApp());
}

class AgroSmartApp extends StatelessWidget {
  const AgroSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AGROSMART',
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/meteo': (context) => const MeteoScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/alertas/plantacao': (context) => const AlertasPlantacaoScreen(),
        '/alertas/sol': (context) => const AlertasSolScreen(),
        '/alertas/irrigacao': (context) => const AlertasIrrigacaoScreen(),
        '/historico-plantacao': (context) => const HistoricoPlantacaoScreen(),
        '/cadastro-plantacao': (context) => const CadastroPlantacaoScreen(),
        '/monitoramento-plantacao':
            (context) => const MonitoramentoPlantacaoScreen(),
        '/suporte': (context) => const SuporteScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/tutorial': (context) => const TutorialScreen(),
      },
    );
  }
}
