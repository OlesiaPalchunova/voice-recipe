import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/model/comments_model.dart';

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

  factory CommentDbManager() {
    return CommentDbManager._internal();
  }

  CommentDbManager._internal();

  Future addNewComment(
      {required Comment comment, required int recipeId}) async {
    try {
      await _db
          .collection(recipesPath)
          .doc(recipeId.toString())
          .collection(commentsPath)
          .add(_buildCommentData(comment));
    } on Error catch(e) {
      debugPrint(e.toString());
    }
  }

  Future updateComment({
  required String newText, required int recipeId, required String commentId}) async {
    try {
      await _db
          .collection(recipesPath)
          .doc(recipeId.toString())
          .collection(commentsPath)
          .doc(commentId)
          .update({
        textField: newText
      });
    } on Error catch(e) {
      debugPrint(e.toString());
    }
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

  Future deleteComment(int recipeId, String id) async {
    try {
      await _db
          .collection(recipesPath)
          .doc(recipeId.toString())
          .collection(commentsPath)
          .doc(id)
          .delete();
    } on Error catch(e) {
      debugPrint(e.toString());
    }
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
