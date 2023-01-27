import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/screens/loading_screen.dart';
import 'package:voice_recipe/screens/not_found_screen.dart';
import 'package:voice_recipe/screens/recipe/recipe_screen.dart';

import '../../model/recipes_info.dart';

class FutureRecipeScreen extends StatelessWidget {
  const FutureRecipeScreen({super.key, required this.recipeId});

  static const route = "/recipe/";

  final int recipeId;

  @override
  Widget build(BuildContext context) {
    if (RecipesGetter().recipesCache.containsKey(recipeId)) {
      return RecipeScreen(recipe: RecipesGetter().recipesCache[recipeId]!);
    }
    return FutureBuilder(
        future: RecipesGetter().getRecipe(recipeId: recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          Recipe? recipe = snapshot.data;
          if (recipe == null) {
            return const NotFoundScreen(
              message: "Рецепт, который вы запрашиваете, не был найден",
            );
          }
          return RecipeScreen(recipe: recipe);
        });
  }
}
