import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/home_screen.dart';
import 'package:voice_recipe/config.dart';

class VoiceRecipeApp extends StatelessWidget {
  const VoiceRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: ThemeData(
          primarySwatch: const MaterialColor(0xFFf07800, Config.colorScheme),
          bottomAppBarColor: const MaterialColor(0xFFf07800, Config.colorScheme)
      ),
    );
  }
}
