import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/components/voice_recipe_media.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                child: Image.asset("assets/images/voice_recipe.png")),
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
