import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillpath/screens/login_screen.dart';
import 'package:skillpath/services/auth_service.dart';
import 'package:skillpath/main.dart'; // We will move MainScreen here or to its own file.

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
} 