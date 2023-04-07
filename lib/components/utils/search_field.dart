import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/labels/input_label.dart';
import 'package:rive/rive.dart';

import '../../model/recipes_info.dart';
import '../../pages/home_page.dart';
import '../../pages/recipe/future_recipe_page.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.focusNode, required this.updateRecipes});

  final FocusNode focusNode;
  final Function(List<Recipe>) updateRecipes;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController controller = TextEditingController();
  SMIBool? hovered;
  List<Recipe> searchResults = [];
  bool showResults = false;

  void _onInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null) return;
    artboard.addController(controller);
    hovered = controller.findInput<bool>('isHover') as SMIBool;
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(switchResultsView);
  }

  void switchResultsView() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        showResults = !showResults;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    widget.focusNode.removeListener(switchResultsView);
    super.dispose();
  }

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  double iconSize(BuildContext context) => Config.isDesktop(context) ? 30 : 15;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Config.isDesktop(context) ? 60 : 40,
          child: InputLabel(
              focusNode: widget.focusNode,
              labelText: "Поиск",
              controller: controller,
              prefixIcon: Container(
                  width: iconSize(context),
                  height: iconSize(context),
                  padding: const EdgeInsets.all(5.0),
                  child: RiveAnimation.asset(
                      "assets/RiveAssets/search$postfix.riv",
                      onInit: _onInit)),
              onChanged: onChanged,
              onSubmit: () => hovered?.change(false)),
        ),
        Visibility(
          visible: showResults,
          child: SingleChildScrollView(
            child: Column(
              children: searchResults.map(buildSearchResult).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSearchResult(Recipe recipe) {
    return InkWell(
      onTap: () {
        navigateToRecipe(context, recipe);
      },
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: Config.borderRadius,
                color: Config.backgroundLightedColor
              ),
              alignment: Alignment.centerLeft,
              padding: Config.paddingAll,
              child: Config.defaultText(recipe.name, fontSize: 16)),
          recipe != searchResults.last ? Container(
            height: .5,
            margin: const EdgeInsets.symmetric(horizontal: Config.padding),
            color: Config.iconColor,
          ) : const SizedBox()
        ],
      ),
    );
  }

  void onChanged(String request) async {
    if (request.isEmpty) {
      hovered?.change(false);
    } else {
      hovered?.change(true);
    }
    if (request.length < 3) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    if (request.length < 3) {
      setState(() {
        searchResults = [];
      });
    }
    var recipes = await RecipesGetter().findRecipes(request, 10);
    if (recipes == null) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    setState(() {
      searchResults = recipes;
    });
  }

  void navigateToRecipe(BuildContext context, Recipe recipe) {
    String route = FutureRecipePage.route + recipe.id.toString();
    String currentRoute = Routemaster.of(context).currentRoute.fullPath;
    if (currentRoute != HomePage.route) {
      route = '$currentRoute/${recipe.id}';
    }
    Routemaster.of(context).push(route);
  }
}
