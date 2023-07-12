// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:voice_recipe/model/comments_model.dart';
//
// import 'package:http/http.dart' as http;
//
// import 'api_fields.dart';
//
//
// class CommentDbManager {
//   static const recipesPath = "recipes";
//   static const commentsPath = "comments";
//   static const usersPath = "users";
//   static const uidField = "uid";
//   static const nameField = "name";
//   static const photoField = "photo";
//   static const postTimeField = "post_time";
//   static const textField = "text";
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   factory CommentDbManager() {
//     return CommentDbManager._internal();
//   }
//
//   CommentDbManager._internal();
//
//   Future addNewComment(
//       {required Comment comment, required int recipeId}) async {
//     try {
//       await _db
//           .collection(recipesPath)
//           .doc(recipeId.toString())
//           .collection(commentsPath)
//           .add(_buildCommentData(comment));
//     } on Error catch(e) {
//       debugPrint(e.toString());
//     }
//   }
//
//   Future<int> sendRecipe(Recipe recipe) async {
//     String? recipeJson = await recipeToJson(recipe);
//     if (recipeJson == null) {
//       return fail;
//     }
//     var response = await http.post(Uri.parse('${apiUrl}commaemts'),
//         headers: {
//           "Content-Type": "application/json; charset=UTF-8",
//         },
//         body: recipeJson);
//     if (response.statusCode != 200) {
//       print(response.bodyBytes);
//       print(response.body);
//       return fail;
//     }
//     var idJson = jsonDecode(response.body);
//     int? recipeId = idJson[id];
//     return recipeId ?? fail;
//   }
//
//   Future updateComment({
//     required String newText, required int recipeId, required String commentId}) async {
//     try {
//       await _db
//           .collection(recipesPath)
//           .doc(recipeId.toString())
//           .collection(commentsPath)
//           .doc(commentId)
//           .update({
//         textField: newText
//       });
//     } on Error catch(e) {
//       debugPrint(e.toString());
//     }
//   }
//
//
//   Map<String, dynamic> _buildCommentData(Comment comment) {
//     return {
//       uidField: comment.uid,
//       postTimeField: comment.postTime.millisecondsSinceEpoch,
//       textField: comment.text,
//       nameField: comment.userName,
//       photoField: comment.profileUrl
//     };
//   }
// }
