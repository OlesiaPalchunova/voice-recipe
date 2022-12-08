import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voice_recipe/model/comments_model.dart';

import '../users_info.dart';

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
      {required Comment comment,
      required int recipeId,
      required int commentId}) async {
    await _db
        .collection(recipesPath)
        .doc(recipeId.toString())
        .collection(commentsPath)
        .doc(commentId.toString())
        .set(_buildCommentData(comment, comment.userName, comment.profilePhotoURL));
  }

  Future<List<Comment>> getComments(int recipeId) async {
    QuerySnapshot<Map<String, dynamic>> res =
        await CommentDbManager().getCommentsDocs(recipeId);
    List<Comment> comments = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in res.docs) {
      comments.add(Comment(
          postTime:
              DateTime.fromMillisecondsSinceEpoch(doc.data()[postTimeField]),
          text: doc.data()[textField],
          userName: doc.data()[nameField],
          uid: doc.data()[uidField],
          profilePhotoURL: doc.data()[photoField]));
    }
    return comments;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCommentsDocs(
      int recipeId) async {
    var res = await _db
        .collection(recipesPath)
        .doc(recipeId.toString())
        .collection(commentsPath)
        .get();
    return res;
  }

  Future deleteComment(String uid, int recipeId, int commentId) async {
    await _db
        .collection(recipesPath)
        .doc(recipeId.toString())
        .collection(commentsPath)
        .doc(commentId.toString())
        .delete();
  }

  Map<String, dynamic> _buildCommentData(
      Comment comment, String name, String photoUrl) {
    return {
      uidField: comment.uid,
      postTimeField: comment.postTime.millisecondsSinceEpoch,
      textField: comment.text,
      nameField: name,
      photoField: photoUrl
    };
  }
}
