import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/model/recipes_info.dart';

class RecipesSet {
  final int id;
  final String name;
  final String imageUrl;
  final List<SetOption> options;

  RecipesSet({required this.id, required this.name, required this.imageUrl,
    required this.options});
}

abstract class SetOption {
  final int id;
  final String name;

  SetOption({required this.id, required this.name});

  Future<List<Recipe>> getRecipes();
}

class TimesSetOption extends SetOption {
  final int minimum;
  final int maximum;

  TimesSetOption({required super.id, required super.name, required this.maximum,
  required this.minimum});

  @override
  Future<List<Recipe>> getRecipes() async {
    return recipes.where((element) {
      var total = element.prepTimeMins + element.cookTimeMins;
      return total >= minimum && total <= maximum;
    }).toList();
  }
}

class StandardSetOption extends SetOption {
  final String collectionName;

  StandardSetOption({required super.id, required super.name, required this.collectionName});

  @override
  Future<List<Recipe>> getRecipes() async {
    var res = await RecipesGetter().getCollection(collectionName);
    return res?? [];
  }
}

final List<SetOption> timesSetOptions = [
  // TimesSetOption(name: "от 3 до 10 минут", maximum: 10, minimum: 3),
  TimesSetOption(id: 1, name: "от 10 до 25 минут", maximum: 25, minimum: 10),
  TimesSetOption(id: 2, name: "от 25 до 40 минут", maximum: 40, minimum: 25),
  TimesSetOption(id: 3, name: "от 40 минут  до 2 часов", maximum: 120, minimum: 40),
];

final List<SetOption> nationalSetOptions = [
  StandardSetOption(id: 1, name: "Русская кухня", collectionName: "russian"),
  StandardSetOption(id: 2, name: "Итальянская кухня", collectionName: "italian"),
  StandardSetOption(id: 3, name: "Американская кухня", collectionName: "american"),
  StandardSetOption(id: 4, name: "Азиатская кухня", collectionName: "asian"),
];

final List<SetOption> premiumSetOptions = [
  StandardSetOption(id: 1, name: "Мишлен", collectionName: "michelin")
];

final List<SetOption> categoriesSetOptions = [
  StandardSetOption(id: 1, name: "Выпечка", collectionName: "bakery"),
  StandardSetOption(id: 2, name: "Супы", collectionName: "soups"),
  StandardSetOption(id: 3, name: "Основные блюда", collectionName: "dishes"),
  StandardSetOption(id: 4, name: "Салаты", collectionName: "salads"),
];

final List<RecipesSet> sets = <RecipesSet>[
  RecipesSet(id: 1, name: "По времени", imageUrl: "assets/images/sets/clock.png", options: timesSetOptions),
  RecipesSet(id: 2, name: "Национальные\nкухни", imageUrl: "assets/images/sets/national.png",
  options: nationalSetOptions),
  RecipesSet(id: 3, name: "Премиальные\nрецепты", imageUrl: "assets/images/sets/premium.png",
  options: premiumSetOptions),
  RecipesSet(id: 4, name: "По виду блюда", imageUrl: "assets/images/sets/business_lunch.png",
  options: categoriesSetOptions),
];

final RecipesSet fav = RecipesSet(id: 5, name: "Избранное", imageUrl: "assets/images/sets/favorites.png",
options: []);
final RecipesSet created = RecipesSet(id: 6, name: "Мои рецепты", imageUrl: "assets/images/sets/created.png",
options: []);

