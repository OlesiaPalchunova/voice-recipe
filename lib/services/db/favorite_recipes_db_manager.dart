import 'package:flutter/cupertino.dart';
import 'package:voice_recipe/services/db/user_db_manager.dart';
import 'package:voice_recipe/services/service_io.dart';

class FavoriteRecipesDbManager {
  final bool initialized = false;
  final List<int> favorites = [];

  factory FavoriteRecipesDbManager() {
    return FavoriteRecipesDbManager._internal();
  }

  FavoriteRecipesDbManager._internal();

  Future<void> initialize() async {
    if (initialized || !ServiceIO.loggedIn) {
      return;
    }
    var user = ServiceIO.user!;
    try {
      var userData = await UserDbManager().getUserData(user.uid);
      List<dynamic> favoritesFromBd = userData[UserDbManager.favorites];
      for (dynamic elem in favoritesFromBd) {
        favorites.add(elem);
      }
    } on Error catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<List<int>> getList() async {
    if (!initialized) {
      await initialize();
    }
    return favorites;
  }

  Future<bool> isFavorite(int recipeId) async {
    if (!initialized) {
      await initialize();
    }
    return favorites.contains(recipeId);
  }

  Future<bool> add(int recipeId) async {
    if (!initialized) {
      await initialize();
    }
    var user = ServiceIO.user!;
    bool added = await UserDbManager().addNewFavorite(user.uid, recipeId);
    if (added) {
      favorites.add(recipeId);
    }
    return added;
  }

  Future<bool> remove(int recipeId) async {
    if (!initialized) {
      await initialize();
    }
    var user = ServiceIO.user!;
    bool removed = await UserDbManager().removeFavorite(user.uid, recipeId);
    if (removed) {
      favorites.remove(recipeId);
    }
    return removed;
  }
}
