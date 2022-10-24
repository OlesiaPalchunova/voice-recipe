import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipe_header.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/components/voice_recipe_media.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "VoiceRecipe",
          style: TextStyle(
              fontFamily: "MontserratBold",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
        leading: const Icon(
          VoiceRecipeMedia.icon,
          size: 30,
          color: Colors.white,
        ),
        // backgroundColor: Colors.amberAccent,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: recipes.length,
        itemBuilder: (_, index) => RecipeHeaderCard(recipe: recipes[index]),
      ),
    );
  }
}
