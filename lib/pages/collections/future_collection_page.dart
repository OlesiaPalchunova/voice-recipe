import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/pages/collections/collection_page.dart';
import 'package:voice_recipe/pages/not_found_page.dart';

import '../../model/recipes_info.dart';
import '../loading_page.dart';

class FutureCollectionPage extends StatelessWidget {
  const FutureCollectionPage({super.key, required this.name});

  static const route = "/collections/";

  final String name;

  @override
  Widget build(BuildContext context) {
    if (RecipesGetter().collectionsCache.containsKey(name)) {
      return CollectionPage(recipes: RecipesGetter().collectionsCache[name]!,
      collectionName: name,);
    }
    return FutureBuilder(
      future: RecipesGetter().getCollection(name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage(postfix: " подборку",);
          }
          List<Recipe>? collection = snapshot.data;
          if (collection == null) {
            return const NotFoundPage(message: "Подборка не найдена",);
          }
          return CollectionPage(recipes: collection, collectionName: name);
        });
  }
}
