import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/model/comments_model.dart';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/api_fields.dart';
import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/services/auth/authorization.dart';
import 'package:voice_recipe/services/db/user_db.dart';

import '../../pages/account/login_page.dart';
import '../auth/Token.dart';


class CommentDbManager {
  static const recipesPath = "recipes";
  static const commentsPath = "comments";
  static const usersPath = "users";
  static const uidField = "uid";
  static const nameField = "name";
  static const photoField = "photo";
  static const postTimeField = "post_time";
  static const textField = "text";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int fail = -1;

  factory CommentDbManager() {
    return CommentDbManager._internal();
  }

  CommentDbManager._internal();

  Future tryAddNewComment(
      {required Comment comment, required int recipeId}) async {
    print("yyyyyyyyyyyyyyyyy");

    String? commentJson = await commentToJson(comment, recipeId);
      print(commentJson);
      if (commentJson == null) {
        return fail;
      }
      var accessToken = await Token.getAccessToken();
      print("SSSSSSSSSSS");
      print(accessToken);
      var response = await http.post(Uri.parse("${apiUrl}comments"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
          body: commentJson);
      print("kkkkkkkkkkkkkkkkkk");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        if (response.statusCode == 401) return 401;
        return fail;
      }
      print("7777777777777");
      var idJson = jsonDecode(response.body);
      int? commentId = idJson[id];
      return commentId ?? fail;
  }

  Future addNewComment(
      {required Comment comment, required int recipeId}) async {
    print("kkkkkkkkkkkkk");
    var status = await tryAddNewComment(comment: comment, recipeId: recipeId);
    print(status);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      print(status_access);

      if (status_access == 200) return await tryAddNewComment(comment: comment, recipeId: recipeId);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryAddNewComment(comment: comment, recipeId: recipeId);
      }
    }
    print("cvcvcvcvcvcv");
    print(recipeId);
    return status;
  }

  Future<String?> commentToJson(Comment comment, int recipeId) async {
    String date = comment.postTime.toString();
    date = date.replaceAll(' ', 'T');
    print(date);
    // String string = DateFormat.format(DateTime.now());
    Map<String, dynamic> commentDto;
    commentDto = {
      "id": 0,
      "user_uid": await UserDB.getUserUid(),
      "recipe_id": recipeId,
      "content": comment.text,
      "post_time": "2017-07-21T17:32:28Z",
    };
    var commentJson = jsonEncode(commentDto);
    return commentJson;
  }

  Future tryUpdateComment({
    required String newText, required int recipeId, required String commentId}) async {
    String? commentJson = await changedCommentToJson(newText, recipeId, int.parse(commentId));

    if (commentJson == null) {
      return fail;
    }
    var accessToken = await Token.getAccessToken();
    var response = await http.put(Uri.parse("${apiUrl}comments"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: commentJson);
    return response.statusCode;
  }

  Future updateComment({
    required String newText, required int recipeId, required String commentId}) async {
    var status = await tryUpdateComment(newText: newText, recipeId: recipeId, commentId: commentId);
    print("iyiyiyiy");
    print(status);
    if (status == 200) return status;

    if (status == 401) {
      print("iiiiiiiiiiiiii  1");
      int status_access = await Authorization.refreshAccessToken();
      print("iiiiiiiiiiiiii  1");
      print(status_access);

      if (status_access == 200) return await tryUpdateComment(newText: newText, recipeId: recipeId, commentId: commentId);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryUpdateComment(newText: newText, recipeId: recipeId, commentId: commentId);
      }
    }
    return status;
  }

  Future<String?> changedCommentToJson(String text, int recipeId, int commentId) async {
    print("aaaaaaaaaaaaaa");
    Map<String, dynamic> commentDto;
    commentDto = {
      "id": commentId,
      "user_uid": await UserDB.getUserUid(),
      "recipe_id": recipeId,
      "content": text,
      "post_time": null,
    };
    var commentJson = jsonEncode(commentDto);
    print(commentJson);
    return commentJson;
  }

  Future<List<Comment>?> getComments1(int recipeId) async {
    var response = await fetchComments(recipeId);
    print(response.statusCode);
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var commentsJson = jsonDecode(decodedBody);

    // var commentsJson = allcommentsJson["comments"];
    List<Comment> comments = [];
    for (var commentJson in commentsJson) {
      Comment comment = commentFromJson(commentJson);
      // if (blackList.contains(recipe.name)) continue;
      comments.add(comment);
      print(comment.text);
      print(comment.id);
      print(comment.postTime);
    }
    return comments;
  }

  Comment commentFromJson(dynamic commentJson) {
    print("llllllllll");
    // var date = DateTime.parse(commentJson["post_time"]);
    // print(date);
    Comment comment = Comment(
        id: commentJson["id"],
        uid: commentJson["user_uid"],
        userName: commentJson["user_uid"],
        postTime: commentJson["post_time"] != null ? DateTime.parse(commentJson["post_time"]) : DateTime.now(),
        text: commentJson["content"],
        profileUrl: defaultProfileUrl,
    );

    return comment;
  }

  Future<http.Response> fetchComments(int recipeId) async {
    var collectionUri = Uri.parse('${apiUrl}comments/$recipeId');
    return http.get(collectionUri);
  }

  Future tryDeleteComment(String id) async {
    var accessToken = await Token.getAccessToken();
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}comments/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("fffffffffffff");
    print(response.statusCode);
    print(accessToken);

    return response.statusCode;
  }

  Future deleteComment(String id) async {
    var status = await tryDeleteComment(id);
    if (status == 200) return status;

    if (status == 401) {
      int status_access = await Authorization.refreshAccessToken();
      if (status_access == 200) return await tryDeleteComment(id);
      if (status_access == 401) {
        int status_refresh = await Authorization.refreshTokens();
        if (status_refresh == 200) return await tryDeleteComment(id);
      }
    }
    return status;
  }

  Map<String, dynamic> _buildCommentData(Comment comment) {
    return {
      uidField: comment.uid,
      postTimeField: comment.postTime.millisecondsSinceEpoch,
      textField: comment.text,
      nameField: comment.userName,
      photoField: comment.profileUrl
    };
  }
}
