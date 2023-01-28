import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserDbManager {
  static const usersPath = "users";
  static const vkLink = "vk_link";
  static const okLink = "ok_link";
  static const tgLink = "tg_link";
  static const info = "info";
  static const favorites = "favorites";
  static const created = "created";
  static const displayName = "display_name";
  static const imageUrl = "image_url";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  factory UserDbManager() {
    return UserDbManager._internal();
  }

  UserDbManager._internal();

  Future addNewUserData(String uid, String displayName, String profileImageUrl) async {
    try {
      await _db.collection(usersPath)
          .doc(uid).set(_buildInitialUserData(displayName, profileImageUrl));
    } on Error catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getUserData(String uid) async {
    try {
      var res = await _db.collection(usersPath).doc(uid).get();
      return res;
    } on Error catch(_) {
      rethrow;
    }
  }

  Future<bool> containsUserData(String uid) async {
    try {
      var res = await _db.collection(usersPath).doc(uid).get();
      return res.exists;
    } on Error catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> addNewFavorite(String uid, int recipeId) async {
    return _addRecipeToList(uid, recipeId, favorites);
  }

  Future<bool> addNewCreated(String uid, int recipeId) async {
    return _addRecipeToList(uid, recipeId, created);
  }

  Future<bool> removeFavorite(String uid, int recipeId) async {
    return _removeRecipeFromList(uid, recipeId, favorites);
  }

  Future<bool> removeCreated(String uid, int recipeId) async {
    return _removeRecipeFromList(uid, recipeId, created);
  }

  Future<bool> _addRecipeToList(String uid, int recipeId, String listName) async {
    bool contains = await containsUserData(uid);
    if (!contains) {
      return false;
    }
    try {
      var userData = await getUserData(uid);
      var list = userData[listName];
      if (list.contains(recipeId)) {
        return true;
      }
      list.add(recipeId);
      return updateField(uid, listName, list);
    } on Error catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> _removeRecipeFromList(String uid, int recipeId, String listName) async {
    bool contains = await containsUserData(uid);
    if (!contains) {
      return false;
    }
    try {
      var userData = await getUserData(uid);
      var list = userData[listName];
      if (!list.contains(recipeId)) {
        return true;
      }
      list.remove(recipeId);
      return updateField(uid, listName, list);
    } on Error catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateField(String uid, String field, dynamic value) async {
    bool contains = await containsUserData(uid);
    if (!contains) {
      return false;
    }
    try {
      _db.collection(usersPath).doc(uid).update({
        field : value
      });
      return true;
    } on Error catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Map<String, dynamic> _buildInitialUserData(String name, String profileImageUrl) {
    return {
      vkLink : "",
      okLink : "",
      tgLink : "",
      info : "",
      favorites : <int>[],
      created : <int>[],
      displayName : name,
      imageUrl : profileImageUrl
    };
  }
}
