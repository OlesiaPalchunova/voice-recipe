import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/model/comments_model.dart';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/api_fields.dart';

import '../auth/Token.dart';

class RateDbManager{
  static const int fail = -1;

  factory RateDbManager() {
    return RateDbManager._internal();
  }

  RateDbManager._internal();

  Future addNewMark(
      {required int mark, required int recipeId, required String userUid}) async {
    String? markJson = await rateToJson(mark, recipeId, userUid);
    print(markJson);
    if (markJson == null) {
      return fail;
    }
    var accessToken = Token.getAccessToken();
    var response = await http.post(Uri.parse("${apiUrl}marks"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: markJson);
    if (response.statusCode != 200) {
      print(response.body);
      print("8888888888888888");
      print(response.statusCode);
      return fail;
    }
    print("66666666");
    print(response.statusCode);
    var idJson = jsonDecode(response.body);
    int? markId = idJson[id];
    return markId ?? fail;
  }

  Future<String?> rateToJson(int mark, int recipeId,  String userUid) async {
    Map<String, dynamic> markDto;
    markDto = {
      "id": null,
      "user_uid": "root",
      "recipe_id": recipeId,
      "mark": mark,
    };
    var markJson = jsonEncode(markDto);
    return markJson;
  }

  Future updateMark({
    required int id, required String userUid, required int recipeId, required double mark}) async {
    String? markJson = await changedCommentToJson(id, userUid, recipeId, mark);
    if (markJson == null) {
      return fail;
    }
    var response = await http.put(Uri.parse("${apiUrl}marks"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: markJson);
    if (response.statusCode != 200) {
      print(response.bodyBytes);
      print(response.body);
      return fail;
    }
    return;
  }

  Future<String?> changedCommentToJson(int id, String userUid, int recipeId, double mark) async {

    Map<String, dynamic> commentDto;
    commentDto = {
      "id": id,
      "use_uid": "root",
      "recipe_id": recipeId,
      "mark": mark,
    };
    var commentJson = jsonEncode(commentDto);
    return commentJson;
  }

  static Future<http.Response> deleteMark(int id) async {
    var accessToken = Token.getAccessToken();
    String? markJson = await deleteMarkToJson(id);
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}marks'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("zzzzzzzzzzzzz");
    print(response.body);

    return response;
  }

  static Future<String?> deleteMarkToJson(int id) async {
    
    print("zzzzzzzzzzzzz");

    Map<String, dynamic> markDto;
    markDto = {
      "recipe_id": id,
      // "user_uid": Token.getUid(),
    };
    var commentJson = jsonEncode(markDto);
    return commentJson;
  }

}
