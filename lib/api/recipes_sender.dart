import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/model/dropped_file.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/api/api_fields.dart';

import '../services/auth/Token.dart';

class RecipesSender {
  static const int fail = -1;
  static RecipesSender singleton = RecipesSender._internal();

  RecipesSender._internal();

  factory RecipesSender() {
    return singleton;
  }

  Future<int> sendRecipe(Recipe recipe) async {
    print("ooooooooooooooooo1");
    String? recipeJson = await recipeToJson(recipe);

    print(7777777777777);
    print(recipeJson);
    if (recipeJson == null) {
      return fail;
    }
    print("ooooooooooooooooo12");
    var accessToken = await Token.getAccessToken();
    var response = await http.post(Uri.parse('${apiUrl}recipes'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: recipeJson);
    print("ooooooooooooooooo2");
    print(response.body);
    if (response.statusCode != 200) {
      // print(response.bodyBytes);
      // print(response.body);
      return fail;
    }
    var idJson = jsonDecode(response.body);
    int? recipeId = idJson[id];
    return recipeId ?? fail;
  }

  Future<String?> recipeToJson(Recipe recipe) async {
    int faceId;
    if (recipe.faceImageRaw == null) {
      faceId = await sendImage(recipe.faceImageUrl);
    } else {
      faceId = await sendImageRaw(recipe.faceImageRaw!);
      print("!!!!!!!!!!!!!");
      print(faceId);
    }
    print("------------");
    if (fail == faceId) {
      print("YYYYYYYYYYYYYYYYYYYYYYYYYYY");
      return null;
    }
    List<int>? mediaIds = await loadAllRecipeMedia(recipe.steps);
    if (mediaIds == null) {
      return null;
    }
    List<Map<String, dynamic>> ingsDto = [];
    int count = 0;
    print("//////////////");
    for (Ingredient ing in recipe.ingredients) {
      print(count);
      print(ing.name.toLowerCase());
      print(ing.measureUnit.toLowerCase());
      print(ing.count);
      ingsDto.add({
        ingredientId:count++,
        ingName: ing.name.toLowerCase(),
        ingUnitName: ing.measureUnit.toLowerCase(),
        ingCount: ing.count
      });
    }
    List<Map<String, dynamic>> stepsDto = [];
    count = 0;
    print("//////////////");
    for (RecipeStep step in recipe.steps) {
      print(mediaIds[count] == 0 ? null : mediaIds[count]);
      print(step.description);
      print(step.id);
      print(step.waitTime > 0 ? step.waitTime : null);
      stepsDto.add({
        stepMedia: mediaIds[count] == 0 ? null : mediaIds[count],
        stepDescription: step.description,
        stepNum: step.id,
        stepWaitTime: step.waitTime > 0 ? step.waitTime : null
      });
      count++;
    }
    print("//////////////");
    print(recipe.name);
    print(faceId);
    print(recipe.cookTimeMins);
    print(recipe.prepTimeMins > 0 ? recipe.prepTimeMins : null);
    print(recipe.kilocalories > 0 ? recipe.kilocalories : null);
    print(recipe.proteins as double?);
    print(recipe.fats as double?);
    print(recipe.carbohydrates as double?);
    Map<String, dynamic> recipeDto = {
      name: recipe.name,
      faceMedia: faceId,
      id: 0,
      cookTimeMins: recipe.cookTimeMins,
      authorId: recipe.user_uid,
      prepTimeMins: recipe.prepTimeMins > 0 ? recipe.prepTimeMins : null,
      kilocalories: recipe.kilocalories > 0 ? recipe.kilocalories : null,
      proteins: recipe.proteins as double?,
      fats: recipe.fats as double?,
      carbohydrates: recipe.carbohydrates as double?,
      ingredientsDistributions: ingsDto,
      steps: stepsDto,
      portions: recipe.portions
    };
    var recipeJson = jsonEncode(recipeDto);
    return recipeJson;
  }

  Future<List<int>?> loadAllRecipeIngredients(List<Ingredient> ings) async {
    if (ings.isEmpty) {
      return null;
    }
    var res = <int>[];
    for (Ingredient ing in ings) {
      int returnCode = await sendIngredient(ing);
      if (returnCode == fail) {
        return null;
      }
      res.add(returnCode);
    }
    return res;
  }

  Future<int> sendIngredient(Ingredient ing) async {
    Map<String, dynamic> ingDto = {
      ingName: ing.name.toLowerCase(),
      ingUnitName: ing.measureUnit.toLowerCase(),
      ingCount: ing.count,
      ingredientId: ing.id + 10
    };
    var response = await http.post(Uri.parse('${apiUrl}recipes'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(ingDto));
    if (response.statusCode != 200) {
      return fail;
    }
    var idJson = jsonDecode(response.body);
    int? ingId = idJson[id];
    if (ingId == null) {
      return fail;
    }
    return ingId;
  }

  Future<List<int>?> loadAllRecipeMedia(List<RecipeStep> steps) async {
    if (steps.isEmpty) {
      return null;
    }
    var res = <int>[];
    for (RecipeStep step in steps) {
      if (!step.hasImage) {
        res.add(0);
        continue;
      }
      int returnCode;
      if (step.rawImage != null) {
        returnCode = await sendImageRaw(step.rawImage!);
      } else {
        // returnCode = await sendImage(step.imgUrl);
        returnCode = 0;
      }
      if (returnCode == fail) {
        return null;
      }
      res.add(returnCode);
    }
    return res;
  }

  Future<bool> makeCollection(String collectionName) async {
    var res =
        await http.post(Uri.parse("${apiUrl}collections?name=$collectionName"));
    return res.statusCode == 200;
  }

  Future<bool> addToCollection(String collectionName, int recipeId) async {
    var res = await http.post(Uri.parse(
        "${apiUrl}collections/content?collections=$collectionName&recipes=$recipeId"));
    return res.statusCode == 200;
  }

  Future<int> sendImageRaw(DroppedFile file) async {
    print(file.mime);
    print(file.size.toString());
    print(file.bytes);
    var accessToken = await Token.getAccessToken();
    var response = await http.post(
      Uri.parse('${apiUrl}media'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        "Content-Type": file.mime,
        "Content-Length": file.size.toString()
      },
      body: file.bytes,
    );
    if (response.statusCode != 200) {
      print(response.body);
      print(response.statusCode);

      return fail;
    }
    var idJson = jsonDecode(response.body);
    print("ID JSON: $idJson");
    int? imageId = idJson[id];
    if (imageId == null) {
      return fail;
    }
    return imageId;
  }

  Future<int> sendImage(String imageUrl) async {
    http.Response imageResponse = await http.get(Uri.parse(imageUrl));
    if (imageResponse.statusCode != 200) {
      return fail;
    }
    var response = await http.post(
      Uri.parse('${apiUrl}media'),
      headers: imageResponse.headers,
      body: imageResponse.bodyBytes,
    );
    if (response.statusCode != 200) {
      // debugPrint(response.body);
      return fail;
    }
    var idJson = jsonDecode(response.body);
    int? imageId = idJson[id];
    if (imageId == null) {
      return fail;
    }
    return imageId;
  }
}
