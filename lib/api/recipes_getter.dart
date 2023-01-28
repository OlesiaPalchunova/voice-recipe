import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/recipes_sender.dart';

import '../config/config.dart';
import '../model/db/user_db_manager.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/api/api_fields.dart';
import 'package:voice_recipe/model/db/favorite_recipes_db_manager.dart';
import 'package:voice_recipe/services/service_io.dart';

class RecipesGetter {
  static RecipesGetter singleton = RecipesGetter._internal();
  static const List<String> blackList = [];
  RecipesGetter._internal();
  final Map<int, Recipe> recipesCache = {};
  final Map<String, List<Recipe>> collectionsCache = {};

  factory RecipesGetter() {
    return singleton;
  }

  Future<List<Recipe>> get _favoriteRecipes async {
    if (!ServiceIO.loggedIn) return [];
    List<int> favIds = await FavoriteRecipesDbManager().getList();
    List<Recipe> res = [];
    for (int id in favIds) {
      Recipe? recipe = await getRecipe(recipeId: id);
      if (recipe != null) {
        res.add(recipe);
      }
    }
    return res;
  }

  Future<List<Recipe>> get _createdRecipes async {
    if (!ServiceIO.loggedIn) return [];
    var user = ServiceIO.user!;
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
    return "${apiUrl}media/$id";
  }

  Future<List<Recipe>?> getCollection(String name) async {
    if (name == 'favorites') {
      return _favoriteRecipes;
    }
    if (name == 'created') {
      return _createdRecipes;
    }
    if (collectionsCache.containsKey(name)) {
      return collectionsCache[name];
    }
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
    collectionsCache[name] = recipes;
    for (Recipe recipe in recipes) {
      recipesCache[recipe.id] = recipe;
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
          hasImage: s[stepMedia][id] != RecipesSender.defaultMediaId,
          description: s[stepDescription],
          waitTime: waitTimeMins
      ));
    }
    num cookTime = recipeJson[cookTimeMins];
    num? prepTime = recipeJson[prepTimeMins];
    num? kilocaloriesCount = recipeJson[kilocalories];
    String recipeName = recipeJson[name];
    for (int i = 0; i < recipeName.length; i++) {
      if (recipeName.substring(i).startsWith("- пошаговый")) {
        recipeName = recipeName.substring(0, i).trim();
        break;
      }
    }
    var recipe = Recipe(
        name: recipeName,
        faceImageUrl: getImageUrl(recipeJson[faceMedia][id]),
        id: recipeJson[id],
        cookTimeMins: cookTime.floor(),
        prepTimeMins: prepTime == null ? 0 : prepTime.floor(),
        kilocalories: kilocaloriesCount == null ? 0.0 : kilocaloriesCount as double,
        ingredients: ingredients,
        steps: recipeSteps,
    );
    return recipe;
  }

  Future<Recipe?> getRecipe({required int recipeId}) async {
    if (recipesCache.containsKey(recipeId)) {
      return recipesCache[recipeId];
    }
    var response = await fetchRecipe(recipeId);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var recipeJson = jsonDecode(decodedBody);
    Recipe recipe = recipeFromJson(recipeJson);
    recipesCache[recipeId] = recipe;
    return recipe;
  }

  Future<http.Response> fetchRecipe(int id) async {
    var recipeUrl = Uri.parse('${apiUrl}recipe/$id');
    return http.get(recipeUrl);
  }

  Future<http.Response> fetchCollection(String name) async {
    var collectionUri = Uri.parse('${apiUrl}collection/search?name=$name');
    return http.get(collectionUri);
  }
}
