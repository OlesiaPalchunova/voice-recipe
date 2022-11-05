import 'dart:math';

import 'package:flutter/material.dart';

import '../model/recipes_info.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';
import 'package:voice_recipe/util.dart';

class RecipeHeaderCard extends StatelessWidget {
  const RecipeHeaderCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const borderRadius = 16.0;
  static const maxWidth = 380.0;
  static const maxHeight = 290.0;

  double _getCardWidth(BuildContext context) {
    var screenWidth = Config.pageWidth(context);
    return min(screenWidth * 0.9, maxWidth);
  }

  double _getCardHeight(BuildContext context) {
    var screenHeight = Config.pageHeight(context);
    return max(screenHeight * 0.3, maxHeight);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToRecipe(context, recipe);
      },
      child: Card(
          color: Colors.white.withOpacity(0),
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 7),
          child: Stack(children: [
            SizedBox(
              height: _getCardHeight(context),
              width: _getCardWidth(context),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image(
                    image: AssetImage(recipe.faceImageUrl),
                    fit: BoxFit.fitHeight,
                  )),
            ),
            Container(
              width: _getCardWidth(context),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87.withOpacity(0.8),
                    Colors.black87.withOpacity(0.0),
                  ]
                ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(borderRadius))),
              // width: double.infinity,
              padding: const EdgeInsets.fromLTRB(30, 35, 0, 50),
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

  void _navigateToRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RecipeScreen(recipe: recipe)));
  }
}
