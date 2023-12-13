import 'dart:convert';

import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/services/db/rate_db.dart';

import '../../api/api_fields.dart';
import 'package:http/http.dart' as http;

import '../../model/category.dart';
import '../../model/category_model.dart';
import '../../model/recipes_info.dart';
import '../../model/sets_info.dart';
import '../auth/Token.dart';
import '../auth/authorization.dart';

class CategoryDB{
  Future<Map<int, Collection>> getCategories() async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
    };

    var response = await http.get(Uri.parse('${apiUrl}categories'), headers: headers);

    print("((((((getCategories))))))");
    print(response.statusCode);


    var decodedBody = utf8.decode(response.body.codeUnits);
    var categoriesJson;
    if (decodedBody != "") categoriesJson = jsonDecode(decodedBody);

    Map<int, Collection> categories = {};
    for (var category in categoriesJson) {
      categories[category["id"]] = Collection(
        id: category["id"],
        name: category["name"],
        collectionName:  category["name"],
      );
    }
    return categories;
  }

  // static Future tryAddRecipeToCategory(int recipe_id, int category_id) async {
  //   var accessToken = await Token.getAccessToken();
  //   final http.Response response = await http.delete(
  //     Uri.parse('${apiUrl}categories/recipes/id=$recipe_id?category_id=$category_id'),
  //     headers: <String, String>{
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   return response.statusCode;
  // }
  //
  // Future getCategoriesOfRecipe({required int recipe_id}) async {
  //   var status = await tryGetCategoriesOfRecipe(recipe_id);
  //   if (status == 200) return status;
  //
  //   if (status == 401) {
  //     int status_access = await Authorization.refreshAccessToken();
  //     if (status_access == 200) return await tryGetCategoriesOfRecipe(recipe_id);
  //     if (status_access == 401) {
  //       int status_refresh = await Authorization.refreshTokens();
  //       if (status_refresh == 200) return await tryGetCategoriesOfRecipe(recipe_id);
  //     }
  //   }
  //   return status;
  // }

  Future<List<CategoryModel>> getCategoriesOfRecipe(int recipeId) async {
    // var accessToken = await Token.getAccessToken();
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
      // 'Authorization': 'Bearer $accessToken',
    };

    var response = await http.get(Uri.parse('${apiUrl}recipes/$recipeId/categories'), headers: headers);

    print("((((((CategoryModel)))))))");
    print(response.statusCode);
    print(response.body);
    print(response.request);

    var decodedBody = utf8.decode(response.body.codeUnits);
    var categoriesJson;
    if (decodedBody != "") categoriesJson = jsonDecode(decodedBody);

    List<CategoryModel> categories = [];
    for (var category in categoriesJson) {
      categories.add( CategoryModel(
        id: category["id"],
        name: category["name"],
      ));
    }
    return categories;
  }

  static Future<Map<int, Recipe>?> getCategory({required int id, required int limit}) async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
    };
    var categoryUri = Uri.parse('${apiUrl}categories/$id?limit=$limit');
    var response = await http.get(categoryUri, headers: headers);

    print("(((((getCategory)))))");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200) {
      print(response.body);
      print(response.statusCode);
      print(response.request);
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var categoryJson = jsonDecode(decodedBody);
    List<dynamic> recipesJson = categoryJson;
    Map<int, Recipe> recipes = {};
    for (dynamic recipeJson in recipesJson) {
      Recipe recipe = RecipesGetter().recipeFromJson(recipeJson);
      double mark = await RateDbManager().getMark(recipe.id);
      recipe.mark = mark;
      recipes[recipe.id] = recipe;
    }
    return recipes;
  }

  static Future tryDeleteCollection(int id, int recipe_id) async {
    var accessToken = await Token.getAccessToken();
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}categories/$id?recipe_id=$recipe_id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future deleteRecipeFromCategory({required int category_id, required int recipe_id}) async {
    var status = await tryDeleteCollection(category_id, recipe_id);

    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      if (status_access == 200) return await tryDeleteCollection(category_id, recipe_id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryDeleteCollection(category_id, recipe_id);
      }
    }
    return status;
  }

  static Future tryAddRecipeToCategory(int recipe_id, int category_id) async {
    var accessToken = await Token.getAccessToken();
    final http.Response response = await http.post(
      Uri.parse('${apiUrl}categories/recipes/$recipe_id?category_id=$category_id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("((((connect))))");
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  static Future addRecipeToCategory({required int recipe_id, required int category_id}) async {
    var status = await tryAddRecipeToCategory(recipe_id, category_id);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      if (status_access == 200) return await tryAddRecipeToCategory(recipe_id, category_id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryAddRecipeToCategory(recipe_id, category_id);
      }
    }
    return status;
  }

  Future<List<CollectionsSet>> getSelections() async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
    };

    var response = await http.get(Uri.parse('${apiUrl}selections'), headers: headers);
    print("(((((((((response)))))))))");
    print(response.statusCode);

    print(response.body);

    var decodedBody = utf8.decode(response.body.codeUnits);
    var categoriesJson;
    if (decodedBody != "") categoriesJson = jsonDecode(decodedBody);

    List<CollectionsSet> categories = [];
    for (var categoryJson  in categoriesJson) {
      categories.add( CollectionsSet(
          id: categoryJson["id"],
          name: categoryJson["name"]
      ));
    }
    return categories;
  }

  Future<List<Collection>> getCategoriesOfSelections({required int selection_id}) async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
    };

    var response = await http.get(Uri.parse('${apiUrl}selections/$selection_id'), headers: headers);

    print("777777777777777777");
    print(response.statusCode);
    print(response.body);

    var decodedBody = utf8.decode(response.body.codeUnits);
    var categoriesJson;
    if (decodedBody != "") categoriesJson = jsonDecode(decodedBody);

    List<Collection> categories = [];
    for (var categoryJson in categoriesJson) {
      categories.add( Collection(
        id: categoryJson["id"],
        name: categoryJson["name"],
        collectionName: categoryJson["name"],
      ));
    }
    return categories;
  }

}