import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_recipe/components/sidebar_menu/navigation_drawer_example.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/config.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid && Config.darkModeOn) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Config.backgroundColor(),
          systemNavigationBarIconBrightness: Brightness.light));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config.darkModeOn ? Colors.black87 : Config.colorScheme[80],
          title: const Text(
            "Voice Recipe",
            style: TextStyle(
                fontFamily: "MontserratBold",
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          centerTitle: true,
          leading:
              Container(
                padding: const EdgeInsets.all(5),
                  child: Image.asset("assets/images/voice_recipe.png")
              ),
        ),
        drawer: NavigationDrawerWidget(onUpdate: () => setState(() {})),
        body: Container(
          color: Config.backgroundColor(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: recipes.length,
            itemBuilder: (_, index) => RecipeHeaderCard(recipe: recipes[index]),
          ),
        )
    );
  }
}
