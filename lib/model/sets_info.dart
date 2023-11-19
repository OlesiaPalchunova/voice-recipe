import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/services/db/category_db.dart';

class CollectionsSet {
  final int id;
  final String name;

  CollectionsSet({required this.id, required this.name});

  // List<CollectionsSet> sets = [];
  //
  // Future initSelections() async {
  //   print("9999");
  //   sets = await CategoryDB().getSelections();
  // }
}

List<CollectionsSet> sets = [];

Future initSelections() async {
  sets = await CategoryDB().getSelections();
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

// final List<Collection> timesSetOptions = [
//   Collection(id: 1, name: "от 10 до 25 минут", collectionName: "time1"),
//   Collection(id: 2, name: "от 25 до 40 минут", collectionName: "time2"),
//   Collection(id: 3, name: "от 40 минут  до 2 часов", collectionName: "time3"),
// ];
//
// final List<Collection> nationalSetOptions = [
//   Collection(id: 1, name: "Русская кухня", collectionName: "russian"),
//   Collection(id: 2, name: "Итальянская кухня", collectionName: "italian"),
//   Collection(id: 3, name: "Американская кухня", collectionName: "american"),
//   Collection(id: 4, name: "Азиатская кухня", collectionName: "asian"),
// ];
//
// final List<Collection> premiumSetOptions = [
//   Collection(id: 1, name: "Мишлен", collectionName: "michelin")
// ];
//
// final List<Collection> categoriesSetOptions = [
//   Collection(id: 1, name: "Выпечка", collectionName: "bakery"),
//   Collection(id: 2, name: "Супы", collectionName: "soups"),
//   Collection(id: 3, name: "Основные блюда", collectionName: "dishes"),
//   Collection(id: 4, name: "Салаты", collectionName: "salads"),
// ];

// final List<CollectionsSet> sets = <CollectionsSet>[
//   CollectionsSet(id: 1, name: "По времени"),
//   CollectionsSet(id: 2, name: "Национальные\nкухни"),
//   CollectionsSet(id: 3, name: "Премиальные\nрецепты"),
//   CollectionsSet(id: 4, name: "По виду блюда"),
// ];

final CollectionsSet fav = CollectionsSet(id: 5, name: "Избранное");
final CollectionsSet created = CollectionsSet(id: 6, name: "Мои рецепты");
