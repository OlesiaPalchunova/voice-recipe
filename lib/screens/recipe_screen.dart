import 'package:flutter/material.dart';
import 'package:voice_recipe/components/recipe_face.dart';
import 'package:voice_recipe/components/recipe_ingredients.dart';
import 'package:voice_recipe/components/recipe_step.dart';

import 'package:voice_recipe/model/recipe_header.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _slideId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe"),
        centerTitle: true,
      ),
      body: Container(
        child: getSlide(_slideId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _slideId++;
        }),
      ),
    );
  }

  Widget getSlide(int slideId) {
    if (slideId == 0) {
      return RecipeFace(recipe: widget.recipe,);
    } else if (slideId == 1) {
      return RecipeIngredients(recipe: widget.recipe);
    }
    return RecipeStepWidget(recipe: widget.recipe, idx: slideId - 1);
  }
}
