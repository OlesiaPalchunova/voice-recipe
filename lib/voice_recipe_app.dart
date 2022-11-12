import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/home_screen.dart';
import 'package:voice_recipe/themes/styles.dart';
import 'package:voice_recipe/themes/dark_theme_provider.dart';

import 'config.dart';

class VoiceRecipeApp extends StatefulWidget {
  const VoiceRecipeApp({super.key});

  @override
  State<VoiceRecipeApp> createState() => _VoiceRecipeAppState();
}

class _VoiceRecipeAppState extends State<VoiceRecipeApp> {
  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.isDarkTheme =
    true;//await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: ThemeData(
      primarySwatch: const MaterialColor(0xFFf07800, Config.colorScheme),
      bottomAppBarColor: const MaterialColor(0xFFf07800, Config.colorScheme))
      // theme: Styles.themeData(themeChangeProvider.isDarkTheme, context),
      // darkTheme: FlexThemeData.dark(
      //     scheme: FlexScheme.hippieBlue,
      // ),
      // themeMode: ThemeMode.dark,
    );
  }
}
