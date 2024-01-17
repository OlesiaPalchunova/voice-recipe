import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../config/config.dart';
import '../../model/collection.dart';
import '../../model/recipes_info.dart';
import '../../pages/home_page.dart';
import '../../pages/profile_collection/specific_collections_page.dart';
import '../../pages/recipe/future_recipe_page.dart';

class RecipeSearchResult extends StatefulWidget {
  const RecipeSearchResult({key, required this.recipe, required this.collection, required this.isRecipe});

  final bool isRecipe;
  final Recipe? recipe;
  final Collection? collection;

  @override
  State<RecipeSearchResult> createState() => _RecipeSearchResultState();
}

class _RecipeSearchResultState extends State<RecipeSearchResult> {
  bool hovered = false;

  Recipe? get recipe => widget.recipe;
  Collection? get collection => widget.collection;
  bool get isRecipe => widget.isRecipe;

  Color get color => !hovered ? Colors.transparent : Config.backgroundLightedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        borderRadius: Config.borderRadius,
        color: color
      ),
      child: InkWell(
        onTap: () {
          // navigateToRecipe(context, recipe);
          if (isRecipe) {
            navigateToRecipe(context, recipe!);
          } else {
            navigateToCollection(context, collection!);
          }
        },
        onHover: (h) => setState(() => hovered = h),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                      const EdgeInsets.symmetric(vertical: Config.padding).add(
                          const EdgeInsets.symmetric(horizontal: Config.padding / 2)),
                      child: isRecipe ?
                          Text(
                            recipe!.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Config.iconColor,
                              fontFamily: Config.fontFamily,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                          :
                          Text(
                            collection!.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Config.iconColor,
                              fontFamily: Config.fontFamily,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                  ),
                ),
                Expanded(
                    child: SizedBox(
                      height: 80,
                      child: ClipRRect(
                        borderRadius: Config.borderRadius,
                        child: isRecipe ?
                        Image.network(recipe!.faceImageUrl, fit: BoxFit.cover,)
                            : Image.network(collection!.imageUrl, fit: BoxFit.cover,),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToRecipe(BuildContext context, Recipe recipe) {
    print("route:");
    String route = FutureRecipePage.route + recipe.id.toString();
    print("route: $route");
    String currentRoute = Routemaster.of(context).currentRoute.fullPath;
    print("route: $currentRoute");
    print(HomePage.route);
    if (currentRoute != HomePage.route) {
      route = '$currentRoute/${recipe.id}';
      print("route: $route");
    }
    Routemaster.of(context).push(route);
  }

  void navigateToCollection(BuildContext context, Collection collection) {
    String route = SpecificCollectionPage.route + collection.id.toString();
    // String currentRoute = Routemaster.of(context).currentRoute.fullPath;
    // if (currentRoute != HomePage.route) {
    //   route = '$currentRoute/${collection.id}';
    // }
    Routemaster.of(context).push(route);
  }
}
