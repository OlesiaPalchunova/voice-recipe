import 'package:voice_recipe/model/recipes_info.dart';

import '../services/db/collection_db.dart';
import '../services/db/user_db.dart';
import 'collection.dart';
import 'collection_model.dart';

class CollectionsInfo{
  static List<Collection> all = [];
  static Collection myCollection = Collection(id: 0, name: "Default", count: 0, imageUrl: "Default");
  static Collection favoriteCollection = Collection(id: 0, name: "Default", count: 0, imageUrl: "Default");
  static List<Collection> restCollections = [];
  static Map<int, Recipe>? favoriteRecipes = new Map<int, Recipe>();


  static Future init() async{
    print(UserDB.uid);
    all.clear();
    await CollectionDB.getCollections(all, UserDB.uid);
    int i = 0;
    restCollections.clear();
    print(all.length);
    for (var collection in all) {
      print(i);
      i++;
      if (collection.name == UserDB.uid + "_saved") {
        myCollection = collection;
      }
      else if (collection.name == UserDB.uid + "_liked") {
        favoriteCollection = collection;
      }
      else restCollections.add(collection);
    }
    favoriteRecipes = await CollectionDB.getCollection(favoriteCollection.id);
  }

  static void delete() {
    restCollections = [];
    myCollection = Collection(id: 0, name: "Default", count: 0, imageUrl: "Default");
    favoriteCollection = Collection(id: 0, name: "Default", count: 0, imageUrl: "Default");
    favoriteRecipes ={};
  }

}