import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:voice_recipe/model/recipes_info.dart';

class RecipesGetter {
  static RecipesGetter singleton = RecipesGetter._internal();
  RecipesGetter._internal();

  factory RecipesGetter() {
    return singleton;
  }

  String getImageUrl(int id) {
    return "http://185.128.106.56:8080/api/v1/media/$id";
  }

  Future<String> getRecipe({required int id}) async {
    var response = await fetchRecipe(id);
    debugPrint(response.statusCode.toString());
    var decodedBody = utf8.decode(response.body.codeUnits);
    debugPrint(decodedBody);
    var recipeJson = jsonDecode(decodedBody);
    debugPrint(recipeJson["name"]);
    List<dynamic> ingredientsJson = recipeJson["ingredients"];
    List<Ingredient> ingredients = [];
    for (dynamic i in ingredientsJson) {
      double count = i["count"];
      if (count.floor() == count) {

      }
      ingredients.add(Ingredient(
          id: i["ingredient_id"],
          name: i["name"],
          count: "${i["count"]} ${i["measure_unit_name"]}"
      ));
      debugPrint(i["name"]);
    }
    List<dynamic> stepsJson = recipeJson["steps"];
    List<RecipeStep> steps = [];
    for (dynamic s in stepsJson) {
      debugPrint(s["description"]);
      steps.add(RecipeStep(
          id: s["step_num"],
          imgUrl: getImageUrl(s["media"]["id"]),
          description: s["description"]
      ));
    }
    double cookTimeMins = recipeJson["cook_time_mins"];
    double? prepTimeMins = recipeJson["prep_time_mins"];
    double kilocalories = recipeJson["kilocalories"];
    var recipe = Recipe(
        name: recipeJson["name"],
        faceImageUrl: getImageUrl(recipeJson["media"]["id"]),
        id: id,
        cookTimeMins: cookTimeMins.floor(),
        prepTimeMins: prepTimeMins == null ? 0 : prepTimeMins.floor(),
        kilocalories: kilocalories.floor(),
        ingredients: ingredients,
        steps: steps,
        isNetwork: true
    );
    recipes.add(recipe);
    return response.statusCode.toString();
  }

  static const serverUrl = "185.128.106.56:8080";

  Future<http.Response> fetchRecipe(int id) async {
    var recipeUrl = Uri.parse('http://185.128.106.56:8080/api/v1/recipe/$id');
    return http.get(recipeUrl);
  }
}
