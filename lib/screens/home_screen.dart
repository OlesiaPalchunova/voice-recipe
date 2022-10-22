import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipe_header.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';

void handle() {
  print("Button has pressed");
}

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VoiceRecipe"),
        centerTitle: true,
        // backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        color: Colors.orangeAccent,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: recipes.length,
          itemBuilder: (_, index) => RecipeHeaderCard(recipe: recipes[index]),
        ),
      ),
    );
  }
}
