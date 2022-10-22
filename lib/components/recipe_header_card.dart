import 'package:flutter/material.dart';

import '../model/recipe_header.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';

class RecipeHeaderCard extends StatelessWidget {
  const RecipeHeaderCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 40,
        margin: const EdgeInsets.symmetric(vertical: 7),
        child: ListTile(
          hoverColor: Colors.black12,
          dense: false,
          title: Text(
            recipe.name,
            style: const TextStyle(
                fontSize: 22,
                fontFamily: "Montserrat",
                color: Colors.black87),
          ),
          contentPadding: const EdgeInsets.all(10),
          leading: Image(
            image: AssetImage(recipe.faceImageUrl),
          ),
          onTap: () => _navigateToNextScreen(context, recipe),
        ));
  }

  void _navigateToNextScreen(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        RecipeScreen(recipe: recipe)));
  }
}
