import 'package:flutter/material.dart';
import 'package:voice_recipe/screens/home_screen.dart';

class VoiceRecipeApp extends StatelessWidget {
  VoiceRecipeApp({super.key});

  final Map<int, Color> color =
  {
    50:const Color.fromRGBO(136,14,79, .1),
    100:const Color.fromRGBO(136,14,79, .2),
    200:const Color.fromRGBO(136,14,79, .3),
    300:const Color.fromRGBO(136,14,79, .4),
    400:const Color.fromRGBO(136,14,79, .5),
    500:const Color.fromRGBO(136,14,79, .6),
    600:const Color.fromRGBO(136,14,79, .7),
    700:const Color.fromRGBO(136,14,79, .8),
    800:const Color.fromRGBO(136,14,79, .9),
    900:const Color.fromRGBO(136,14,79, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: ThemeData(
          primarySwatch: MaterialColor(0xFF880E4F, color),
          bottomAppBarColor: MaterialColor(0xFF880E4F, color)
      ),
    );
  }
}
