import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/db/user_db_manager.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/api/recipe_fields.dart';

class RecipesGetter {
  static RecipesGetter singleton = RecipesGetter._internal();
  RecipesGetter._internal();

  factory RecipesGetter() {
    return singleton;
  }

  String getImageUrl(int id) {
    return "https://$serverUrl/api/v1/media/$id";
  }

  Future<List<Recipe>> get favoriteRecipes async {
    if (!Config.loggedIn) return [];
    var user = Config.user!;
    var userData = await UserDbManager().getUserData(user.uid);
    var favIds = userData[UserDbManager.favorites];
    return recipes.where((element) => favIds.contains(element.id)).toList();
  }

  Future<List<Recipe>> get createdRecipes async {
    if (!Config.loggedIn) return [];
    var user = Config.user!;
    var userData = await UserDbManager().getUserData(user.uid);
    var favIds = userData[UserDbManager.created];
    List<Recipe> result = [];
    for (int id in favIds) {
      Recipe? recipe = await RecipesGetter().getRecipe(recipeId: id);
      if (recipe == null) {
        continue;
      }
      result.add(recipe);
    }
    return result;
  }

  Future<Recipe?> getRecipe({required int recipeId}) async {
    var response = await fetchRecipe(recipeId);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var recipeJson = jsonDecode(decodedBody);
    List<dynamic> ingredientsJson = recipeJson["ingredients_distributions"];
    List<Ingredient> ingredients = [];
    for (dynamic i in ingredientsJson) {
      double count = i[ingCount];
      if (count.floor() == count) {

      }
      ingredients.add(Ingredient(
          id: i[ingredientId],
          name: i[ingName],
          measureUnit: i[ingUnitName],
          count: i[ingCount]
      ));
    }
    List<dynamic> stepsJson = recipeJson[steps];
    List<RecipeStep> recipeSteps = [];
    for (dynamic s in stepsJson) {
      var waitTimeMinsRef = s[stepWaitTime];
      int waitTimeMins = 0;
      if (waitTimeMinsRef != null) {
        waitTimeMins = waitTimeMinsRef;
      }
      recipeSteps.add(RecipeStep(
          id: s[stepNum],
          imgUrl: getImageUrl(s[stepMedia][id]),
          description: s[stepDescription],
          waitTime: waitTimeMins
      ));
    }
    double cookTime = recipeJson[cookTimeMins];
    double? prepTime = recipeJson[prepTimeMins];
    double? kilocaloriesCount = recipeJson[kilocalories];
    var recipe = Recipe(
        name: recipeJson[name],
        faceImageUrl: getImageUrl(recipeJson[faceMedia][id]),
        id: recipeId + recipes.length - 1,
        cookTimeMins: cookTime.floor(),
        prepTimeMins: prepTime == null ? 0 : prepTime.floor(),
        kilocalories: kilocaloriesCount?? 0,
        ingredients: ingredients,
        steps: recipeSteps,
        isNetwork: true
    );
    return recipe;
  }

  static const serverUrl = "server.voicerecipe.ru";

  Future<http.Response> fetchRecipe(int id) async {
    var recipeUrl = Uri.parse('https://server.voicerecipe.ru/api/v1/recipe/$id');
    return http.get(recipeUrl);
  }
}
