import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/model/comments_model.dart';

import 'package:http/http.dart' as http;
import 'package:voice_recipe/api/api_fields.dart';

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

  Future addNewComment(
      {required Comment comment, required int recipeId}) async {
      String? commentJson = await commentToJson(comment, recipeId);
      print(commentJson);
      if (commentJson == null) {
        return fail;
      }
      var accessToken = Token.getToken();
      print("SSSSSSSSSSS");
      print(accessToken);
      var response = await http.post(Uri.parse("${apiUrl}comments"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json; charset=UTF-8",
        },
          body: commentJson);
      if (response.statusCode != 200) {
        print(response.body);
        return fail;
      }
      print("7777777777777");
      var idJson = jsonDecode(response.body);
      int? commentId = idJson[id];
      return commentId ?? fail;
  }

  Future<String?> commentToJson(Comment comment, int recipeId) async {
    String date = comment.postTime.toString();
    date = date.replaceAll(' ', 'T');
    print(date);
    // String string = DateFormat.format(DateTime.now());
    Map<String, dynamic> commentDto;
    commentDto = {
      "user_uid": "root",
      "recipe_id": recipeId,
      "content": comment.text,
      "post_time": date,
    };
    var commentJson = jsonEncode(commentDto);
    return commentJson;
  }

  Future updateComment({
    required String newText, required int recipeId, required String commentId}) async {
    String? commentJson = await changedCommentToJson(newText, recipeId, int.parse(commentId));
    if (commentJson == null) {
      return fail;
    }
      var response = await http.put(Uri.parse("${apiUrl}comments"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: commentJson);
    if (response.statusCode != 200) {
      print(response.bodyBytes);
      print(response.body);
      return fail;
    }
    return;
  }

  Future<String?> changedCommentToJson(String text, int recipeId, int commentId) async {

    List<Map<String, dynamic>> commentDto = [];
    commentDto.add({
      "id": commentId,
      "recipe_id": recipeId,
      "content": text,
    });
    var commentJson = jsonEncode(commentDto);
    return commentJson;
  }

  Future<Map<String, Comment>> getComments(int recipeId) async {
    QuerySnapshot<Map<String, dynamic>> res;
    try {
      res = await CommentDbManager().getCommentsDocs(recipeId);
    } on Error catch(e) {
      debugPrint('Failed to get comments');
      debugPrint(e.toString());
      return {};
    }
    var comments = <String, Comment>{};
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in res.docs) {
      try {
        comments[doc.id] = Comment(
            id: 665,
            postTime: DateTime.fromMillisecondsSinceEpoch(doc.data()[postTimeField]),
            text: doc.data()[textField],
            uid: doc.data()[uidField],
            userName: doc.data()[nameField],
            profileUrl: doc.data()[photoField]
        );
      } on Error catch(e) {
        debugPrint(e.toString());
    }
    }
    return comments;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCommentsDocs(
      int recipeId) async{
    try {
      var res = await _db
          .collection(recipesPath)
          .doc(recipeId.toString())
          .collection(commentsPath)
          .get();
      return res;
    } on Error catch(_) {
      rethrow;
    }
  }

  Future<List<Comment>?> getComments1(int recipeId) async {
    print("11111111");
    var response = await fetchComments(recipeId);
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
    // String date = commentJson["post_time"].replaceAll('Z', ' ');
    var date = DateTime.parse(commentJson["post_time"]);
    // print(date.toISOString().replace('Z', ''));
    Comment comment = Comment(
        id: commentJson["id"],
        uid: commentJson["user_uid"],
        userName: "dbfgn",
        postTime: DateTime.parse(commentJson["post_time"]),
        text: commentJson["content"],
        profileUrl: "",
    );

    return comment;
  }

  Future<http.Response> fetchComments(int recipeId) async {
    var collectionUri = Uri.parse('${apiUrl}comments/$recipeId');
    return http.get(collectionUri);
  }

  // Future deleteComment(int recipeId, String id) async {
  //   try {
  //     await _db
  //         .collection(recipesPath)
  //         .doc(recipeId.toString())
  //         .collection(commentsPath)
  //         .doc(id)
  //         .delete();
  //   } on Error catch(e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future<http.Response> deleteComment(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('${apiUrl}comments/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
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
