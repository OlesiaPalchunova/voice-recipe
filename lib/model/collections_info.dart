import 'package:voice_recipe/model/recipes_info.dart';

import '../services/db/collection_db.dart';
import '../services/db/user_db.dart';
import 'collection_model.dart';

class CollectionsInfo{
  static List<CollectionModel> all = [];
  static CollectionModel myCollection = CollectionModel(id: 0, name: "Default", count: 0, imageUrl: "Default");
  static CollectionModel favoriteCollection = CollectionModel(id: 0, name: "Default", count: 0, imageUrl: "Default");
  static List<CollectionModel> restCollections = [];
  static Map<int, Recipe>? favoriteRecipes = new Map<int, Recipe>();


  static Future init() async{
    print("(((((CollectionsInfo)))))");
    print(UserDB.uid);
    var uid = await UserDB.getUserUid;
    await CollectionDB.getCollections(all, UserDB.uid);
    int i = 0;
    for (var collection in all) {
      print(i);
      i++;
      if (collection.name == UserDB.uid + "_saved") {
        myCollection = collection;
      }
      else if (collection.name == UserDB.uid + "_liked") {
        favoriteCollection = collection;
      } else restCollections.add(collection);
    }
    favoriteRecipes = await CollectionDB.getCollection(favoriteCollection.id);
  }


}