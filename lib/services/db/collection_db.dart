import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:voice_recipe/model/collection.dart';
import 'package:voice_recipe/services/db/rate_db.dart';

import '../../api/api_fields.dart';
import '../../api/recipes_sender.dart';
import '../../model/collection_model.dart';
import '../../model/collections_info.dart';
import '../../model/dropped_file.dart';
import '../../model/recipes_info.dart';
import '../auth/Token.dart';
import '../auth/authorization.dart';
import '../service_io.dart';

class CollectionDB{
  static Future tryAddCollection(
      {required Collection collection, required DroppedFile? imageFile, required String name}) async {

    String? collectionJson = await collectionToJson(collection, imageFile, name);
    if (collectionJson == null) {
      return -1;
    }
    var accessToken = await Token.getAccessToken();
    print(accessToken);
    var response = await http.post(Uri.parse("${apiUrl}collections?name=$name"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: collectionJson
    );
    print("010101");
    print(response.statusCode);
    print(response.body);

    // print(response.body);
    if (response.statusCode != 200) {
      if (response.statusCode == 401) return 401;
      return -1;
    }
    print("010122");
    // var idJson = jsonDecode(response.body);
    // int? commentId = idJson[id];
    print("010122");
    return 200;
  }

  static Future addCollection(
      {required Collection collection, required DroppedFile? imageFile, required String name}) async {
    print("kkkkkk222kkkkkkk");
    var status = await tryAddCollection(collection: collection, imageFile: imageFile, name: name);
    print(status);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryAddCollection(collection: collection, imageFile: imageFile, name: name);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryAddCollection(collection: collection, imageFile: imageFile, name: name);
      }
    }
    return status;
  }

  static Future<String?> collectionToJson(Collection collection, DroppedFile? imageFile, String name) async {

    var imageId = null;
    if (imageFile != null) imageId = await RecipesSender().sendImageRaw(imageFile);

    Map<String, dynamic> collectionDto;
    collectionDto = {
      "name": name,
      "number": 0,
      "id": 0,
      "media_id": imageId
    };
    var collectionJson = jsonEncode(collectionDto);
    return collectionJson;
  }

  static Future tryUpdateCollection(
      {required Collection collection, required DroppedFile? imageFile, required String name, required int id, required String imageUrl}) async {

    var imageId = null;
    if (imageFile != null) {
      imageId = await RecipesSender().sendImageRaw(imageFile);
      collection.imageUrl = getImageUrl(imageId);
    }

    Map<String, dynamic> collectionDto;
    collectionDto = {
      "name": name,
      "number": 0,
      "id": id,
      "media_id": imageId ?? getIdFromImageUrl(imageUrl)
    };
    var collectionJson = jsonEncode(collectionDto);

    if (collectionJson == null) {
      return -1;
    }
    var accessToken = await Token.getAccessToken();
    print(accessToken);
    var response = await http.put(Uri.parse("${apiUrl}collections?collection_id=$id"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: collectionJson
    );
    print("010101");
    print(imageId ?? getIdFromImageUrl(imageUrl));
    print(id);
    print(response.statusCode);
    print(response.body);

    // print(response.body);
    if (response.statusCode != 200) {
      if (response.statusCode == 401) return 401;
      return -1;
    }
    print("010122");
    // var idJson = jsonDecode(response.body);
    // int? commentId = idJson[id];
    print("010122");
    return response.statusCode;
  }

  static Future updateCollection(
      {required Collection collection, required DroppedFile? imageFile, required String name, required int id, required String imageUrl}) async {
    print("kkkkkk222kkkkkkk");
    var status = await tryUpdateCollection(collection: collection, imageFile: imageFile, name: name, id: id, imageUrl: imageUrl);
    print(status);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryUpdateCollection(collection: collection, imageFile: imageFile, name: name, id: id, imageUrl: imageUrl);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryUpdateCollection(collection: collection, imageFile: imageFile, name: name, id: id, imageUrl: imageUrl);
      }
    }
    return status;
  }

  // static Future<String?> collectionUpadateToJson(Collection collection, DroppedFile? imageFile, String name) async {
  //
  //   var imageId = null;
  //   if (imageFile != null) imageId = await RecipesSender().sendImageRaw(imageFile);
  //
  //   Map<String, dynamic> collectionDto;
  //   collectionDto = {
  //     "name": name,
  //     "number": 0,
  //     "id": 0,
  //     "media_id": imageId
  //   };
  //   var collectionJson = jsonEncode(collectionDto);
  //   return collectionJson;
  // }


  static String getImageUrl(int id) {
    return "${apiUrl}media/$id";
  }

  static int getIdFromImageUrl(String imageUrl) {
    final parts = imageUrl.split('/');
    if (parts.length >= 2) {
      print(parts.last);
      return int.parse(parts.last);
    } else {
      return -1;
    }
  }

  static Future getCollections(List<Collection> collections, String login) async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
    };

    var response = await http.get(Uri.parse('${apiUrl}collections?login=$login'), headers: headers);
    print("3636363");
    print(response.statusCode);
    print(response.body);

    var decodedBody = utf8.decode(response.body.codeUnits);
    var colectionsJson;
    if (decodedBody != "") colectionsJson = jsonDecode(decodedBody);
    print("kkkkkkkkkkk");
    print(colectionsJson);

    // List<CollectionModel> collections = [];

    for (dynamic i in colectionsJson) {
      print(i);
      print(collections.length);
      collections.add(Collection(
        id: i["id"],
        name: i["name"],
        count: i["number"],
        imageUrl: i["media_id"] != null ? getImageUrl(i["media_id"]) : "https://www.obedsmile.ru/images/stories/article/kak-pravilno-est-sladkoe.jpg",
      ));
    }

    return 1;

  }

  static Future tryDeleteCollection(int id) async {
    var accessToken = await Token.getAccessToken();
    print(id);
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}collections?id=$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("fffffffffffff");
    print(response.statusCode);
    print(response.body);
    print(accessToken);

    return response.statusCode;
  }

  static Future deleteCollection(int id) async {
    var status = await tryDeleteCollection(id);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      if (status_access == 200) return await tryDeleteCollection(id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryDeleteCollection(id);
      }
    }
    return status;
  }


  static Future<Map<int, Recipe>?> getCollection(int id) async {
    var response = await fetchCollection(id);
    print(response.statusCode);
    // print(response.body);
    // print(response.request);
    if (response.statusCode != 200) {
      print(response.body);
      print(response.statusCode);
      print(response.request);
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<dynamic> recipesJson = collectionJson;
    // List<Recipe> recipes = [];
    Map<int, Recipe> recipes = {};
    int count = 0;
    for (dynamic recipeJson in recipesJson) {
      count++;
      Recipe recipe = recipeFromJson(recipeJson);
      double mark = await RateDbManager().getMark(recipe.id);
      print("+++++++++++++++++++++++++++++=");
      print(mark);
      recipe.mark = mark;
      recipes[recipe.id] = recipe;
    }
    return recipes;
  }

  static Recipe recipeFromJson(dynamic recipeJson) {

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
    int portion = recipeJson["servings"] ?? 0;
    print("999779999999");
    print(portion);
    print(recipeName);
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

  static Future<http.Response> fetchCollection(int id) async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
      // Add more custom headers as needed
    };
    print("kkkkkkkkkkkkk");
    // var collectionUri = Uri.parse('${apiUrl}collections/search?name=$name&page=$pageId');
    var collectionUri = Uri.parse('${apiUrl}collections/$id');
    print("kkkkkkkkkkkkk");
    return http.get(collectionUri, headers: headers);
  }

  static Future tryConnectCollection(
      {required int collection_id, required int recipe_id}) async {
    var accessToken = await Token.getAccessToken();
    print(accessToken);
    var response = await http.post(Uri.parse("${apiUrl}collections/content?collection_id=$collection_id&recipe_id=$recipe_id"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        }
    );
    print("010101");
    print(response.statusCode);
    print(response.body);

    // print(response.body);
    if (response.statusCode != 200) {
      if (response.statusCode == 401) return 401;
      return -1;
    }
    print("010122");
    // var idJson = jsonDecode(response.body);
    // int? commentId = idJson[id];
    print("010122");
    return -1;
  }

  static Future connectCollection(
      {required int collection_id, required int recipe_id}) async {
    print("kkkkkk222kkkkkkk");
    var status = await tryConnectCollection(collection_id: collection_id, recipe_id: recipe_id);
    print(status);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryConnectCollection(collection_id: collection_id, recipe_id: recipe_id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryConnectCollection(collection_id: collection_id, recipe_id: recipe_id);
      }
    }
    return status;
  }


  static Future tryAddLikedCollection(
      {required int recipe_id}) async {
    var accessToken = await Token.getAccessToken();
    print(accessToken);
    var response = await http.post(Uri.parse("${apiUrl}collections/liked?recipe_id=$recipe_id"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        }
    );
    print("010101");
    print(response.statusCode);
    print(response.body);
    print(response.request);

    // print(response.body);
    if (response.statusCode != 200) {
      if (response.statusCode == 401) return 401;
      return -1;
    }
    print("010122");
    // var idJson = jsonDecode(response.body);
    // int? commentId = idJson[id];
    print("010122");
    return response.statusCode;
  }

  Future addLikedCollection(
      {required int recipe_id}) async {
    print("kkkkkk222kkkkkkk");
    var status = await tryAddLikedCollection(recipe_id: recipe_id);
    print(status);
    if (status == 200) {
      CollectionsInfo.init();
      return status;
    }

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) {
        CollectionsInfo.init();
        return await tryAddLikedCollection(recipe_id: recipe_id);
      }
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) {
          CollectionsInfo.init();
          return await tryAddLikedCollection(recipe_id: recipe_id);
        }
      }
    }
    return status;
  }

  static Future tryDeleteRecipeFromCollection(int collection_id, int recipe_id) async {
    var accessToken = await Token.getAccessToken();
    print(id);
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}collections/content?collection_id=$collection_id&recipe_id=$recipe_id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("fffffffffffff");
    print(response.statusCode);
    print(response.body);
    print(accessToken);

    return response.statusCode;
  }

  Future deleteRecipeFromCollection(int collection_id, int recipe_id) async {
    var status = await tryDeleteRecipeFromCollection(collection_id, recipe_id);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      if (status_access == 200) return await tryDeleteRecipeFromCollection(collection_id, recipe_id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryDeleteRecipeFromCollection(collection_id, recipe_id);
      }
    }
    return status;
  }

  static Future<List<Collection>?> getCollectionsBySearch(String name, int limit) async {
    final Map<String, String> headers = {
      'Custom-Header': 'Custom Value',
    };

    var response = await http.get(Uri.parse('${apiUrl}collections/search/$name?limit=$limit'), headers: headers);
    print("3636363");
    print(response.statusCode);
    print(name);
    print(response.request);

    var decodedBody = utf8.decode(response.body.codeUnits);
    var colectionsJson;
    if (decodedBody != "") colectionsJson = jsonDecode(decodedBody);
    print("kkkkkkkkkkk");
    print(colectionsJson);

    List<Collection> collections = [];

    for (dynamic i in colectionsJson) {
      print(i);
      collections.add(Collection(
        id: i["id"],
        name: i["name"],
        count: i["number"],
        imageUrl: i["media_id"] != null ? getImageUrl(i["media_id"]) : "https://www.obedsmile.ru/images/stories/article/kak-pravilno-est-sladkoe.jpg",
      ));
    }

    return collections;

  }
}





