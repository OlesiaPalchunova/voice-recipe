import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/home_screen.dart';
import 'package:voice_recipe/config.dart';

class VoiceRecipeApp extends StatelessWidget {
  const VoiceRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: FlexThemeData.light(scheme: FlexScheme.hippieBlue),
      darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.hippieBlue,
      ),
      // themeMode: ThemeMode.dark,
    );
  }
}
