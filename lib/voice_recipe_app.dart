import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/home_screen.dart';

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
        home: const Home(),
        theme: Config.darkModeOn ? Config.darkTheme : Config.lightTheme);
  }
}
