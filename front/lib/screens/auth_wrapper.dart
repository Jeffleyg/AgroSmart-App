import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginAndTutorialStatus();
  }

  Future<void> _checkLoginAndTutorialStatus() async {
    final isLoggedIn = await _authService.getToken() != null;
    if (mounted) {
      if (isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenTutorial = prefs.getBool('hasSeenTutorial') ?? false;

        if (hasSeenTutorial) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/tutorial');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
