import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/search/recipe_search_result.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/labels/input_label.dart';
import 'package:rive/rive.dart';

import '../../model/collection.dart';
import '../../model/recipes_info.dart';
import '../../services/db/collection_db.dart';

class SearchField extends StatefulWidget {
  const SearchField({key, required this.focusNode, required this.isRecipeSearch});

  final FocusNode focusNode;
  final bool isRecipeSearch;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController controllerRecipe = TextEditingController();
  TextEditingController controllerCollection = TextEditingController();
  SMIBool? hovered;
  static List<Recipe> searchRecipeResults = [];
  static List<Collection> searchCollectionResults = [];
  static String requestString = "";
  static bool shownAll = false;
  double height = 0;

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
    widget.focusNode.requestFocus();
    // if (widget.isRecipeSearch) controllerRecipe.text = requestString;
    // else controllerCollection.text = requestString;
    onChanged;
  }

  @override
  void dispose() {
    controllerRecipe.text = "";
    controllerCollection.text = "";
    controllerRecipe.dispose();
    controllerCollection.dispose();
    super.dispose();
  }

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  double iconSize(BuildContext context) => Config.isDesktop(context) ? 30 : 15;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          width: 323,
          height: Config.isDesktop(context) ? 60 : 40,
          child: InputLabel(
              focusNode: widget.focusNode,
              labelText: widget.isRecipeSearch ? "Найти рецепт" : "Найти коллекцию",
              controller: widget.isRecipeSearch ? controllerRecipe : controllerCollection,
              prefixIcon: Container(
                  width: iconSize(context),
                  height: iconSize(context),
                  padding: const EdgeInsets.fromLTRB(0.0, 3.0, 5.0, 5.0),
                  child: Icon(
                    Icons.search,
                    color: Config.iconColor,
                  ),
                  // child: RiveAnimation.asset(
                  //     "assets/RiveAssets/search$postfix.riv",
                  //     onInit: _onInit)
                  ),
              onChanged: onChanged,
              onSubmit: onFullRequest),
        ),
        Visibility(
          visible: widget.isRecipeSearch ? searchRecipeResults.isNotEmpty : searchCollectionResults.isNotEmpty,
          child: SizedBox(
              // height: Config.pageHeight(context) * .3,
              height: height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                      decoration: BoxDecoration(
                          color: (widget.isRecipeSearch && searchRecipeResults.isNotEmpty) || (!widget.isRecipeSearch && searchCollectionResults.isNotEmpty)
                              ? Config.activeBackgroundLightedColor
                              : Colors.transparent,
                          borderRadius: Config.borderRadius),
                      child: Column(
                        children: widget.isRecipeSearch ?
                        searchRecipeResults
                            .map((r) => RecipeSearchResult(recipe: r, collection: null, isRecipe: true,))
                            .toList()
                        : searchCollectionResults
                            .map((c) => RecipeSearchResult(recipe: null, collection: c, isRecipe: false,))
                            .toList()
                      ),
                    ),
                    Visibility(
                      visible: ((widget.isRecipeSearch && searchRecipeResults.length >= 10) || (!widget.isRecipeSearch && searchCollectionResults.length >= 10)) && !shownAll,
                      child: ClassicButton(
                          text: "Показать больше результатов",
                          onTap: onFullRequest),
                    )
                  ],
                ),
              )),
        ),
        Visibility(
            visible: !((widget.isRecipeSearch && searchRecipeResults.isNotEmpty) || (!widget.isRecipeSearch && searchCollectionResults.isNotEmpty)) && requestString.isNotEmpty,
            child: Container(
              padding: Config.paddingAll,
              decoration: BoxDecoration(
                  borderRadius: Config.borderRadius,
                  color: Config.backgroundEdgeColor),
              child: Config.defaultText(
                  "К сожалению, по данному запросу не удалось ничего найти",
                  fontSize: 16),
            )),
        Container(
          alignment: Alignment.center,
          height: 60,
          padding: Config.paddingAll,
          child: SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () {
                // searchRecipeResults = [];
                // searchCollectionResults = [];
                // controllerCollection = TextEditingController();
                // controllerRecipe = TextEditingController();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange[300]!), // Set the background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set the text color
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Set the border radius
                    // side: BorderSide(color: Colors.black), // Set the border color
                  ),
                ),
              ),
              child: Text('Скрыть'),
            ),
          ),
        )
      ]),
    );
  }

  void onFullRequest() async {
    hovered?.change(false);
    if (requestString.isEmpty) {
      return;
    }
    shownAll = true;
    var collections;
    var recipes;
    if (widget.isRecipeSearch) {
      recipes = await RecipesGetter().findRecipes(requestString, 30);
      if (recipes == null) {
        setState(() {
          searchRecipeResults = [];
        });
        return;
      }
      setState(() {
        searchRecipeResults = recipes;
      });
    } else {
      collections =
          await CollectionDB.getCollectionsBySearch(requestString, 30);
      if (collections == null) {
        setState(() {
          searchCollectionResults = [];
        });
        return;
      }
      setState(() {
        searchCollectionResults = collections;
      });
    }
    print(collections.length);

  }

  void onChanged(String request, List<String> error) async {
    print((widget.isRecipeSearch && searchRecipeResults.isNotEmpty) || (!widget.isRecipeSearch && searchCollectionResults.isNotEmpty));
    shownAll = false;
    requestString = widget.isRecipeSearch ? controllerRecipe.text : controllerCollection.text;
    if (request.isEmpty) {
      hovered?.change(false);
      setState(() {
        searchRecipeResults = [];
        searchCollectionResults = [];
      });
      return null;
    } else {
      hovered?.change(true);
    }
    var recipes;
    var collections;
    int len;
    if (widget.isRecipeSearch) {
      recipes = await RecipesGetter().findRecipes(requestString, 10);
      setState(() {
        searchRecipeResults = recipes != null ?  recipes : [];
      });
      len = searchRecipeResults.length;
    } else {
      collections = await CollectionDB.getCollectionsBySearch(requestString, 10);
      setState(() {
        searchCollectionResults = collections != null ?  collections : [];

      });
      len = searchCollectionResults.length;
    }
    if (len > 2) height = Config.pageHeight(context) * .3;
    else if (len == 2) height = Config.pageHeight(context) * .27;
    else if (len == 1) height = Config.pageHeight(context) * .15;
    else height = 0;
  }
}
