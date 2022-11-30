import 'dart:collection';

import 'components/buttons/favorites_button.dart';

class WidgetStorage {
  static final _favButtonsMap = HashMap<int, FavoritesButton>();

  factory WidgetStorage() {
    return WidgetStorage._internal();
  }

  WidgetStorage._internal();

  FavoritesButton getFavButton(int recipeId) {
    return FavoritesButton(recipeId: recipeId);
  }
}
