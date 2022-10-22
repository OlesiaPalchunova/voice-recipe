import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipe_header.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';

void handle() {
  print("Button has pressed");
}

class Home extends StatelessWidget {
  final List<RecipeHeader> recipes = [
    RecipeHeader(name: "Борщ", imageUrl: "assets/images/borsh.png", id: 0),
    RecipeHeader(
        name: "Карбонара", imageUrl: "assets/images/carbonara.png", id: 1),
  ];

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
      floatingActionButton: const FloatingActionButton(
        onPressed: handle,
        child: Text("add"),
      ),
    );
  }
}
