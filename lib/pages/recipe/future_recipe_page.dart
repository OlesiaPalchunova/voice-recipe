import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/pages/loading_page.dart';
import 'package:voice_recipe/pages/not_found_page.dart';
import 'package:voice_recipe/pages/recipe/recipe_page.dart';

import '../../model/recipes_info.dart';

class FutureRecipePage extends StatelessWidget {
  const FutureRecipePage({super.key, required this.recipeId});

  static const route = "/recipe/";

  final int recipeId;

  @override
  Widget build(BuildContext context) {
    if (RecipesGetter().recipesCache.containsKey(recipeId)) {
      return RecipePage(recipe: RecipesGetter().recipesCache[recipeId]!);
    }
    return FutureBuilder(
        future: RecipesGetter().getRecipe(recipeId: recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage(postfix: " рецепт",);
          }
          Recipe? recipe = snapshot.data;
          if (recipe == null) {
            return const NotFoundPage(
              message: "Рецепт, который вы запрашиваете, не был найден",
            );
          }
          return RecipePage(recipe: recipe);
        });
  }
}
