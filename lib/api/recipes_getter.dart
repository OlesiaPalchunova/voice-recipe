import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/recipes_sender.dart';

import '../services/auth/Token.dart';
import '../services/auth/authorization.dart';
import '../services/db/rate_db.dart';
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
    print(7777777);
    print(response.request);
    if (response.statusCode != 200) {

      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    List<dynamic> recipesJson = jsonDecode(decodedBody);
    List<Recipe> recipes = [];
    for (dynamic recipeJson in recipesJson) {
      Recipe recipe = recipeFromJson(recipeJson);
      print("aaaaaaaaaaaaaaaaaa");
      print(recipeJson);
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
    print(response.statusCode);
    if (response.statusCode != 200) {
      print(response.body);
      print(response.statusCode);
      print(response.request);
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    // List<dynamic> recipesJson = collectionJson["recipes"];
    List<dynamic> recipesJson = collectionJson;
    List<Recipe> recipes = [];
    int count = 0;
    for (dynamic recipeJson in recipesJson) {
      count++;
      Recipe recipe = recipeFromJson(recipeJson);
      double mark = await RateDbManager().getMark(recipe.id);
      recipe.mark = mark;
      if (blackList.contains(recipe.name)) continue;
      recipes.add(recipe);
      if (count == 20) break;
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
      var waitTimeMinsRef = s[stepWaitTime];
      int waitTimeMins = 0;
      if (waitTimeMinsRef != null) {
        waitTimeMins = waitTimeMinsRef;
      }
      recipeSteps.add(RecipeStep(
          id: s[stepNum],
          imgUrl: s[stepMedia] != null ? getImageUrl(s[stepMedia]) : 'bgf',
          hasImage: s[stepMedia] != null,
          description: s[stepDescription],
          waitTime: waitTimeMins
      ));
    }
    num cookTime = recipeJson[cookTimeMins];
    num? prepTime = recipeJson[prepTimeMins];
    num? kilocaloriesCount = recipeJson[kilocalories];
    String recipeName = recipeJson[name];
    String userUid = recipeJson[authorId];
    double mark = recipeJson["avg_mark"] ?? 0.0;
    int user_mark = recipeJson["user_mark"] ?? 0;
    int? portion = recipeJson["servings"];
    for (int i = 0; i < recipeName.length; i++) {
      if (recipeName.substring(i).startsWith(RegExp(r"(- пошаговый)|\.|/"))) {
        recipeName = recipeName.substring(0, i).trim();
        break;
      }
    }

    var recipe = Recipe(
        name: recipeName,
        faceImageUrl: getImageUrl(recipeJson[faceMedia]),
        id: recipeJson[id],
        user_uid: userUid,
        cookTimeMins: cookTime.floor(),
        prepTimeMins: prepTime == null ? 0 : prepTime.floor(),
        kilocalories: kilocaloriesCount == null ? 0.0 : kilocaloriesCount as double,
        ingredients: ingredients,
        steps: recipeSteps,
        mark: mark,
        user_mark: user_mark,
        portions: portion
    );
    return recipe;
  }

  Future<Recipe?> getRecipe({required int recipeId}) async {

    // if (recipesCache.containsKey(recipeId)) {
    //   return recipesCache[recipeId];
    // }
    var response = await fetchRecipe(recipeId);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var recipeJson = jsonDecode(decodedBody);
    print(recipeJson);
    Recipe recipe = recipeFromJson(recipeJson);
    recipesCache[recipeId] = recipe;
    return recipe;
  }

  Future<http.Response> fetchRecipe(int id) async {
    var accessToken = await Token.getAccessToken();
    print(accessToken);
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
      // Add more custom headers as needed
    };
    var recipeUrl = Uri.parse('${apiUrl}recipes/$id');
    return http.get(recipeUrl, headers: headers);
  }

  Future<http.Response> fetchCollection(String name, int pageId) async {
    print(ServiceIO.loggedIn);
    if (ServiceIO.loggedIn) {
      Authorization.refreshAccessToken();
    }
    var accessToken = await Token.getAccessToken();
    // print(accessToken);
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
      // Add more custom headers as needed
    };
    // var collectionUri = Uri.parse('${apiUrl}collections/search?name=$name&page=$pageId');
    var collectionUri = Uri.parse('${apiUrl}recipes?page=$pageId');
    return http.get(collectionUri, headers: headers);
  }

  Future<http.Response> fetchBySearch(String request, int? limit) async {
    if (ServiceIO.loggedIn) {
      Authorization.refreshAccessToken();
    }
    var accessToken = await Token.getAccessToken();
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
      // Add more custom headers as needed
    };
    String limitPostfix = "";
    if (limit != null) {
      limitPostfix = "?limit=$limit";
    }

    var searchUri = Uri.parse('${apiUrl}recipes/search/$request$limitPostfix');
    return http.get(searchUri, headers: headers);
  }
}
