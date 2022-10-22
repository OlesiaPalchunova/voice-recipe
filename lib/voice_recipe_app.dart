import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/home_screen.dart';

class VoiceRecipeApp extends StatelessWidget {
  const VoiceRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}
