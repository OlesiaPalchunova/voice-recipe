import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/authorization/auth_screen.dart';
import 'package:voice_recipe/screens/authorization/forgot_password_screen.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';
import 'package:voice_recipe/screens/authorization/register_screen.dart';
import 'package:voice_recipe/screens/create_recipe_screen.dart';
import 'package:voice_recipe/screens/home_screen.dart';
import 'package:voice_recipe/screens/profile_screen.dart';
import 'package:voice_recipe/screens/sets_list_screen.dart';
import 'package:voice_recipe/screens/tree.dart';

import 'config.dart';

class VoiceRecipeApp extends StatefulWidget {
  const VoiceRecipeApp({super.key});

  @override
  State<VoiceRecipeApp> createState() => _VoiceRecipeAppState();
}

class _VoiceRecipeAppState extends State<VoiceRecipeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appName,
      initialRoute: Home.route,
      theme: Config.darkModeOn ? Config.darkTheme : Config.lightTheme,
      routes: {
        Home.route: (context) => const Home(),
        CreateRecipeScreen.route: (context) => const CreateRecipeScreen(),
        AuthScreen.route: (context) => const AuthScreen(),
        SetsListScreen.route: (context) => const SetsListScreen(),
        LoginScreen.route: (context) => const LoginScreen(),
        RegisterScreen.route: (context) => const RegisterScreen(),
        ForgotPasswordScreen.route: (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
