import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/recipes_sender.dart';

import '../services/db/user_db_manager.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/api/api_fields.dart';
import 'package:voice_recipe/services/db/favorite_recipes_db_manager.dart';
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

  Future<List<Recipe>?> findRecipes(String request, [int? limit]) async {
    if (request.isEmpty) {
      return null;
    }
    var response = await fetchBySearch(request, limit);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    List<dynamic> recipesJson = jsonDecode(decodedBody);
    List<Recipe> recipes = [];
    for (dynamic recipeJson in recipesJson) {
      Recipe recipe = recipeFromJson(recipeJson);
      if (blackList.contains(recipe.name)) continue;
      recipes.add(recipe);
    }
    return recipes;
  }

  Future<List<Recipe>?> getCollection(String name, [int pageId = 0]) async {
    if (name == 'favorites') {
      return _favoriteRecipes;
    }
    if (name == 'created') {
      return _createdRecipes;
    }
    if (collectionsCache.containsKey('$name$pageId')) {
      return collectionsCache['$name$pageId'];
    }
    var response = await fetchCollection(name, pageId);
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
    collectionsCache['$name$pageId'] = recipes;
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
      print('1');
      var waitTimeMinsRef = s[stepWaitTime];
      int waitTimeMins = 0;
      if (waitTimeMinsRef != null) {
        waitTimeMins = waitTimeMinsRef;
      }
      recipeSteps.add(RecipeStep(
          id: s[stepNum],
          imgUrl: s[stepMedia] != null ? getImageUrl(s[stepMedia][id]) : 'bgf',
          hasImage: s[stepMedia] != null,
          description: s[stepDescription],
          waitTime: waitTimeMins
      ));
    }
    num cookTime = recipeJson[cookTimeMins];
    num? prepTime = recipeJson[prepTimeMins];
    num? kilocaloriesCount = recipeJson[kilocalories];
    String recipeName = recipeJson[name];
    for (int i = 0; i < recipeName.length; i++) {
      if (recipeName.substring(i).startsWith(RegExp(r"(- пошаговый)|\.|/"))) {
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
    var recipeUrl = Uri.parse('${apiUrl}recipes/$id');
    return http.get(recipeUrl);
  }

  Future<http.Response> fetchCollection(String name, int pageId) async {
    var collectionUri = Uri.parse('${apiUrl}collections/search?name=$name&page=$pageId');
    return http.get(collectionUri);
  }

  Future<http.Response> fetchBySearch(String request, int? limit) async {
    String limitPostfix = "";
    if (limit != null) {
      limitPostfix = "?limit=$limit";
    }
    var searchUri = Uri.parse('${apiUrl}recipes/search/$request$limitPostfix');
    return http.get(searchUri);
  }
}
