import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/search/recipe_search_result.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/labels/input_label.dart';
import 'package:rive/rive.dart';

import '../../model/recipes_info.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController controller = TextEditingController();
  SMIBool? hovered;
  static List<Recipe> searchResults = [];
  static String requestString = "";
  static bool shownAll = false;

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
    controller.text = requestString;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  double iconSize(BuildContext context) => Config.isDesktop(context) ? 30 : 15;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: Config.isDesktop(context) ? 60 : 40,
        child: InputLabel(
            focusNode: widget.focusNode,
            labelText: "Поиск",
            controller: controller,
            prefixIcon: Container(
                width: iconSize(context),
                height: iconSize(context),
                padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                child: RiveAnimation.asset(
                    "assets/RiveAssets/search$postfix.riv",
                    onInit: _onInit)),
            onChanged: onChanged,
            onSubmit: onFullRequest),
      ),
      Visibility(
        visible: searchResults.isNotEmpty,
        child: SizedBox(
            height: Config.pageHeight(context) * .4,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                    decoration: BoxDecoration(
                        color: searchResults.isNotEmpty
                            ? Config.activeBackgroundLightedColor
                            : Colors.transparent,
                        borderRadius: Config.borderRadius),
                    child: Column(
                      children: searchResults
                          .map((r) => RecipeSearchResult(recipe: r))
                          .toList(),
                    ),
                  ),
                  Visibility(
                    visible: searchResults.isNotEmpty && !shownAll,
                    child: ClassicButton(
                        text: "Показать больше результатов",
                        onTap: onFullRequest),
                  )
                ],
              ),
            )),
      ),
      Visibility(
          visible: searchResults.isEmpty && requestString.isNotEmpty,
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
          child: ClassicButton(
            text: "Скрыть",
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      )
    ]);
  }

  void onFullRequest() async {
    hovered?.change(false);
    if (requestString.isEmpty) {
      return;
    }
    shownAll = true;
    var recipes = await RecipesGetter().findRecipes(requestString, 30);
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

  void onChanged(String request) async {
    shownAll = false;
    requestString = request;
    if (request.isEmpty) {
      hovered?.change(false);
      setState(() {
        searchResults = [];
      });
      return;
    } else {
      hovered?.change(true);
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
}
