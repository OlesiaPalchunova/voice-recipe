import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/db/user_db_manager.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/api/recipe_fields.dart';
//import 'package:voice_recipe/model/db/favorite_recipes_db_manager.dart';

class RecipesGetter {
  final Map<String, int> recipeIds = {};
  static RecipesGetter singleton = RecipesGetter._internal();
  static const List<String> blackList = [];
  RecipesGetter._internal();

  factory RecipesGetter() {
    return singleton;
  }

  Future<List<Recipe>> get favoriteRecipes async {
    if (!Config.loggedIn) return [];
    // var favIds = await FavoriteRecipesDbManager().getList();
    return [];
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

  String getImageUrl(int id) {
    return "https://$serverUrl/api/v1/media/$id";
  }

  Future<List<Recipe>?> getCollection(String name) async {
    var response = await fetchCollection(name);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<dynamic> recipesJson = collectionJson["recipes"];
    List<Recipe> recipes = [];
    for (dynamic recipeJson in recipesJson) {
      Recipe recipe = recipeFromJson(recipeJson);
      if (blackList.contains(recipe.name)) continue;
      recipes.add(recipe);
    }
    return recipes;
  }

  Recipe recipeFromJson(dynamic recipeJson) {
    List<dynamic> ingredientsJson = recipeJson[ingredientsDistributions];
    List<Ingredient> ingredients = [];
    for (dynamic i in ingredientsJson) {
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
    num cookTime = recipeJson[cookTimeMins];
    num? prepTime = recipeJson[prepTimeMins];
    num? kilocaloriesCount = recipeJson[kilocalories];
    int recipeId = 0;
    String recipeName = recipeJson[name];
    if (recipeIds.containsKey(recipeName)) {
      recipeId = recipeIds[recipeName]!;
    } else {
      recipeId = recipesCounter++;
      recipeIds[recipeName] = recipeId;
    }
    for (int i = 0; i < recipeName.length; i++) {
      if (recipeName.substring(i).startsWith("- пошаговый")) {
        recipeName = recipeName.substring(0, i).trim();
        break;
      }
    }
    var recipe = Recipe(
        name: recipeName,
        faceImageUrl: getImageUrl(recipeJson[faceMedia][id]),
        id: recipeId,
        cookTimeMins: cookTime.floor(),
        prepTimeMins: prepTime == null ? 0 : prepTime.floor(),
        kilocalories: kilocaloriesCount == null ? 0.0 : kilocaloriesCount as double,
        ingredients: ingredients,
        steps: recipeSteps,
    );
    return recipe;
  }

  Future<Recipe?> getRecipe({required int recipeId}) async {
    var response = await fetchRecipe(recipeId);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var recipeJson = jsonDecode(decodedBody);
    return recipeFromJson(recipeJson);
  }

  static const serverUrl = "server.voicerecipe.ru";

  Future<http.Response> fetchRecipe(int id) async {
    var recipeUrl = Uri.parse('https://server.voicerecipe.ru/api/v1/recipe/$id');
    return http.get(recipeUrl);
  }

  Future<http.Response> fetchCollection(String name) async {
    var collectionUri = Uri.parse('https://server.voicerecipe.ru/api/v1/collection/search?name=$name');
    return http.get(collectionUri);
  }
}
