import 'package:flutter/material.dart';

import '../model/recipes_info.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';

class RecipeHeaderCard extends StatelessWidget {
  const RecipeHeaderCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const borderRadius = 16.0;
  static const width = 380.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToNextScreen(context, recipe);
      },
      child: Card(
          color: Colors.white.withOpacity(0),
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 7),
          child: Stack(children: [
            SizedBox(
              height: 260,
              width: width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image(
                    image: AssetImage(recipe.faceImageUrl),
                    fit: BoxFit.fitHeight,
                  )),
            ),
            Container(
              width: width,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87.withOpacity(0.6),
                    Colors.black87.withOpacity(0.0),
                  ]
                ),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius))),
              // width: double.infinity,
              padding: const EdgeInsets.fromLTRB(30, 35, 0, 10),
              child: Text(
                recipe.name,
                style: const TextStyle(
                    fontFamily: "MontserratBold",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ])),
    );
  }

  void _navigateToNextScreen(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)));
  }
}
