import 'dart:collection';
import 'dart:typed_data';
import 'comments_model.dart';

import 'package:voice_recipe/model/dropped_file.dart';

class Recipe {
  int id;
  String name;
  String faceImageUrl;
  int cookTimeMins;
  int prepTimeMins;
  double kilocalories;
  int? proteins;
  int? fats;
  int? carbohydrates;
  List<Ingredient> ingredients;
  List<RecipeStep> steps;
  // List<Comment> comments;

  DroppedFile? faceImageRaw;

  Recipe({required this.name, required this.faceImageUrl, required this.id,
  required this.cookTimeMins, required this.prepTimeMins, required this.kilocalories,
    required this.ingredients, required this.steps, this.faceImageRaw
  });
}

class Ingredient {
  int id;
  String name;
  double count;
  String measureUnit;

  Ingredient({required this.id, required this.name, required this.count, required this.measureUnit});
}

class RecipeStep {
  int id;
  String imgUrl;
  String description;
  int waitTime;
  DroppedFile? rawImage;

  bool hasImage;

  RecipeStep({required this.id, required this.imgUrl, required this.description, this.waitTime = 0, this.hasImage = true,
  this.rawImage});
}

int recipesCounter = 35;

final ratesMap = HashMap<int, int>();

final List<double> rates = [
  4.1, 4.7, 4.1, 4.2, 4.4, 4.9, 4.3,
];
