import 'dart:math';

import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipe_header.dart';

class RecipeStepWidget extends StatelessWidget {
  RecipeStepWidget({
    Key? key,
    required this.recipe,
    required int idx
  }) : super(key: key) {
    int len = stepsResolve[recipe.id].length;
    idx = min(idx - 1, len - 1);
    step = stepsResolve[recipe.id][idx];
  }

  final Recipe recipe;
  late final RecipeStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(step.imgUrl),
            fit: BoxFit.fitHeight,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.75),
              borderRadius: BorderRadius.circular(15)
            ),
            height: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            child: Text(step.description, style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              color: Colors.white
            ),),
          ),
    ));
  }
}
