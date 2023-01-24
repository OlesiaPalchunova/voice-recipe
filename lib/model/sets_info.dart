import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/model/recipes_info.dart';

class CollectionsSet {
  final int id;
  final String name;
  final String imageUrl;
  final List<Collection> options;

  CollectionsSet({required this.id, required this.name, required this.imageUrl,
    required this.options});
}

class Collection {
  final int id;
  final String name;
  final String collectionName;

  Collection({required this.id, required this.name,
  required this.collectionName});

  Future<List<Recipe>> getRecipes() async {
    var res = await RecipesGetter().getCollection(collectionName);
    return res?? [];
  }
}

final List<Collection> timesSetOptions = [
  Collection(id: 1, name: "от 10 до 25 минут", collectionName: "time1"),
  Collection(id: 2, name: "от 25 до 40 минут", collectionName: "time2"),
  Collection(id: 3, name: "от 40 минут  до 2 часов", collectionName: "time3"),
];

final List<Collection> nationalSetOptions = [
  Collection(id: 1, name: "Русская кухня", collectionName: "russian"),
  Collection(id: 2, name: "Итальянская кухня", collectionName: "italian"),
  Collection(id: 3, name: "Американская кухня", collectionName: "american"),
  Collection(id: 4, name: "Азиатская кухня", collectionName: "asian"),
];

final List<Collection> premiumSetOptions = [
  Collection(id: 1, name: "Мишлен", collectionName: "michelin")
];

final List<Collection> categoriesSetOptions = [
  Collection(id: 1, name: "Выпечка", collectionName: "bakery"),
  Collection(id: 2, name: "Супы", collectionName: "soups"),
  Collection(id: 3, name: "Основные блюда", collectionName: "dishes"),
  Collection(id: 4, name: "Салаты", collectionName: "salads"),
];

final List<CollectionsSet> sets = <CollectionsSet>[
  CollectionsSet(id: 1, name: "По времени", imageUrl: "assets/images/sets/clock.png", options: timesSetOptions),
  CollectionsSet(id: 2, name: "Национальные\nкухни", imageUrl: "assets/images/sets/national.png",
  options: nationalSetOptions),
  CollectionsSet(id: 3, name: "Премиальные\nрецепты", imageUrl: "assets/images/sets/premium.png",
  options: premiumSetOptions),
  CollectionsSet(id: 4, name: "По виду блюда", imageUrl: "assets/images/sets/business_lunch.png",
  options: categoriesSetOptions),
];

final CollectionsSet fav = CollectionsSet(id: 5, name: "Избранное", imageUrl: "assets/images/sets/favorites.png",
options: []);
final CollectionsSet created = CollectionsSet(id: 6, name: "Мои рецепты", imageUrl: "assets/images/sets/created.png",
options: []);

