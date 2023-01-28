import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/pages/account/profile_page.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  static const route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const AccountPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
