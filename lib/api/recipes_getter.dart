import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/model/recipes_info.dart';

import '../config.dart';
import '../model/db/user_db_manager.dart';

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
      Recipe? recipe = await RecipesGetter().getRecipe(id: id);
      if (recipe == null) {
        continue;
      }
      result.add(recipe);
    }
    return result;
  }

  Future<Recipe?> getRecipe({required int id}) async {
    var response = await fetchRecipe(id);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var recipeJson = jsonDecode(decodedBody);
    List<dynamic> ingredientsJson = recipeJson["ingredients_distributions"];
    List<Ingredient> ingredients = [];
    for (dynamic i in ingredientsJson) {
      double count = i["count"];
      if (count.floor() == count) {

      }
      ingredients.add(Ingredient(
          id: i["ingredient_id"],
          name: i["name"],
          measureUnit: i["measure_unit_name"],
          count: i["count"]
      ));
    }
    List<dynamic> stepsJson = recipeJson["steps"];
    List<RecipeStep> steps = [];
    for (dynamic s in stepsJson) {
      var waitTimeMinsRef = s["wait_time_mins"];
      int waitTimeMins = 0;
      if (waitTimeMinsRef != null) {
        waitTimeMins = waitTimeMinsRef;
      }
      steps.add(RecipeStep(
          id: s["step_num"],
          imgUrl: getImageUrl(s["media"]["id"]),
          description: s["description"],
          waitTime: waitTimeMins
      ));
    }
    double cookTimeMins = recipeJson["cook_time_mins"];
    double? prepTimeMins = recipeJson["prep_time_mins"];
    double? kilocalories = recipeJson["kilocalories"];
    var recipe = Recipe(
        name: recipeJson["name"],
        faceImageUrl: getImageUrl(recipeJson["media"]["id"]),
        id: id + recipes.length - 1,
        cookTimeMins: cookTimeMins.floor(),
        prepTimeMins: prepTimeMins == null ? 0 : prepTimeMins.floor(),
        kilocalories: kilocalories?? 0,
        ingredients: ingredients,
        steps: steps,
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
