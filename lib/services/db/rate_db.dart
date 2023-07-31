import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/model/comments_model.dart';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/api_fields.dart';
import 'package:voice_recipe/services/db/user_db.dart';

import '../../model/mark.dart';
import '../auth/Token.dart';
import '../auth/authorization.dart';

class RateDbManager{
  static const int fail = -1;
  static double mark = 0.0;

  static var status_create = 0;
  static var status_update = 0;
  static var status_delete = 0;

  factory RateDbManager() {
    return RateDbManager._internal();
  }

  RateDbManager._internal();

  Future tryAddNewMark(
      {required int mark, required int recipeId, required String? userUid}) async {
    String? markJson = await rateToJson(mark, recipeId, userUid);
    print(markJson);
    if (markJson == null) {
      return fail;
    }
    var accessToken = await Token.getAccessToken();
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
      return response.statusCode;
    }
    print("create");
    print(response.statusCode);
    var idJson = jsonDecode(response.body);
    int? markId = idJson[id];
    return response.statusCode;
  }

  Future addNewMark(
      {required int mark, required int recipeId, required String? userUid}) async {
    var status = await tryAddNewMark(mark: mark, recipeId: recipeId, userUid: userUid);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryAddNewMark(mark: mark, recipeId: recipeId, userUid: userUid);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryAddNewMark(mark: mark, recipeId: recipeId, userUid: userUid);
      }
    }
    return status;
  }

  Future<String?> rateToJson(int mark, int recipeId,  String? userUid) async {
    Map<String, dynamic> markDto;
    markDto = {
      "user_uid": userUid,
      "recipe_id": recipeId,
      "mark": mark,
    };
    var markJson = jsonEncode(markDto);
    return markJson;
  }

  Future tryUpdateMark({
    required int id, required String userUid, required int recipeId, required double mark}) async {
    String? markJson = await changedCommentToJson(id, userUid, recipeId, mark);
    if (markJson == null) {
      return fail;
    }
    var accessToken = await Token.getAccessToken();
    var response = await http.put(Uri.parse("${apiUrl}marks"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: markJson);
    print("update");
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future updateMark({
    required int id, required String userUid, required int recipeId, required double mark}) async {
    var status = await tryUpdateMark(id: id, userUid: userUid, recipeId: recipeId, mark: mark);
    print("status: $status");
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryUpdateMark(id: id, userUid: userUid, recipeId: recipeId, mark: mark);
      if (status_access == 401) {
        print("blablabla");
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryUpdateMark(id: id, userUid: userUid, recipeId: recipeId, mark: mark);

      }
    }
    return status;
  }

  Future<String?> changedCommentToJson(int id, String userUid, int recipeId, double mark) async {

    Map<String, dynamic> commentDto;
    commentDto = {
      "user_uid": userUid,
      "recipe_id": recipeId,
      "mark": mark,
    };
    var commentJson = jsonEncode(commentDto);
    return commentJson;
  }

  static Future tryDeleteMark(int id) async {
    var accessToken = await Token.getAccessToken();
    String? markJson = await deleteMarkToJson(id);
    var uid = UserDB.uid;
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}marks?recipe_id=$id&user_uid=$uid'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("delete");
    print(response.statusCode);

    return response.statusCode;
  }

  Future deleteMark(int id) async {
    var status = await tryDeleteMark(id);
    if (status == 200) return status_delete = status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return status_delete = await tryDeleteMark(id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return status_delete = await tryDeleteMark(id);
      }
    }
    return status;
  }

  static Future<String?> deleteMarkToJson(int id) async {
    
    print("zzzzzzzzzzzzz");

    Map<String, dynamic> markDto;
    markDto = {
      "recipe_id": id,
      "user_uid": UserDB.uid,
    };
    var commentJson = jsonEncode(markDto);
    return commentJson;
  }

  Future<int> getMarkById(int recipe_id, String user_uid) async {
    print("11111111");
    var accessToken = await Token.getAccessToken();
    print(accessToken);
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
      // Add more custom headers as needed
    };

    var response = await http.get(Uri.parse('${apiUrl}marks?recipe_id=$recipe_id&user_uid=$user_uid'), headers: headers);
    // var response = await fetchComments(recipeId);
    print("(((((((((((((((((((((((66666666666)))))))))))))))))))))))");
    print(recipe_id);
    print(user_uid);
    print(response.statusCode);
    print(response.body);
    // if (response.statusCode != 200) {
    //   return null;
    // }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var markJson = jsonDecode(decodedBody);

    int mark = markJson["mark"];
    return mark;
  }

  Future<double> getMark(int recipe_id) async {
    // var accessToken = await Token.getAccessToken();
    // print(accessToken);
    final Map<String, String> headers = {
      // 'Authorization': 'Bearer $accessToken',
      'Custom-Header': 'Custom Value',
      // Add more custom headers as needed
    };

    var response = await http.get(Uri.parse('${apiUrl}marks/$recipe_id'), headers: headers);
    print(response.statusCode);

    var decodedBody = utf8.decode(response.body.codeUnits);
    var markJson = 0.0;
    if (decodedBody != "") markJson = jsonDecode(decodedBody);

    double mark = markJson;
    return mark;
  }

  // int markFromJson(dynamic markJson) {
  //   Mark mark = Mark(
  //     recipe_id: markJson["id"],
  //     user_uid: markJson["user_uid"],
  //     mark: markJson["mark"]
  //   );
  //
  //   return markJson["mark"];
  // }

}
