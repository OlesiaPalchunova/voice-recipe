import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../config/config.dart';
import '../../model/recipes_info.dart';
import '../../pages/home_page.dart';
import '../../pages/recipe/future_recipe_page.dart';

class RecipeSearchResult extends StatefulWidget {
  const RecipeSearchResult({key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeSearchResult> createState() => _RecipeSearchResultState();
}

class _RecipeSearchResultState extends State<RecipeSearchResult> {
  bool hovered = false;

  Recipe get recipe => widget.recipe;

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
          navigateToRecipe(context, recipe);
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
                      child: Config.defaultText(recipe.name, fontSize: 16)),
                ),
                Expanded(
                    child: SizedBox(
                      height: 80,
                      child: ClipRRect(
                        borderRadius: Config.borderRadius,
                        child: Image.network(recipe.faceImageUrl, fit: BoxFit.cover,),
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
}
