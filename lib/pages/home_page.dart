import 'package:flutter/material.dart';
import 'package:voice_recipe/components/advertisement.dart';
import 'package:voice_recipe/sidebar_menu/side_bar_menu.dart';
import 'package:voice_recipe/components/utils/slider_gesture_handler.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/components/utils/search_field.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../api/recipes_getter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  final List<RecipeHeaderCard> recipeViews = [];
  final List<Advertisement> adViews = [];
  bool disposed = false;
  final searchFocusNode = FocusNode();
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  static int currentPage = 0;
  static int maxPage = 30;
  static const collectionName = 'diamond';

  @override
  void initState() {
    initRecipeViews();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (currentPage >= maxPage) return;
    if (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      return;
    }
    setState(() => isLoadingMore = true);
    await fetchNewRecipesPortion();
    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    disposed = true;
    super.dispose();
  }

  Future<void> fetchNewRecipesPortion() async {
    var newPortion =
        await RecipesGetter().getCollection(collectionName, currentPage++);
    if (newPortion != null) {
      recipes.addAll(newPortion);
      recipes = recipes;
      recipeViews
          .addAll(newPortion.map((e) => RecipeHeaderCard(recipe: e)).toList());
    }
  }

  void initRecipeViews() async {
    List<Recipe>? mainPage =
        await RecipesGetter().getCollection(collectionName, currentPage++);
    if (mainPage != null) {
      recipes.addAll(mainPage);
    }
    adViews.add(const Advertisement());
    recipeViews
        .addAll(recipes.map((e) => RecipeHeaderCard(recipe: e)).toList());
    if (!disposed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Config.darkThemeProvider,
        builder: (context, darkModeOn, child) {
          return Scaffold(
              appBar: Config.defaultAppBar,
              drawerScrimColor: Config.drawerScrimColor,
              drawer: const SideBarMenu(),
              body: SafeArea(
                child: Builder(builder: buildMainContent),
              ));
        });
  }

  Widget buildMainContent(BuildContext context) {
    return SliderGestureHandler(
      handleKeyboard: false,
      ignoreVerticalSwipes: false,
      handleSideTaps: false,
      customOnTap: () => searchFocusNode.unfocus(),
      onRight: () {},
      onEscape: () {},
      onLeft: () => Scaffold.of(context).openDrawer(),
      child: Scrollbar(
        thickness: Config.isDesktop(context) ? 20 : 0,
        radius: const Radius.elliptical(6, 12),
        controller: scrollController,
        interactive: true,
        thumbVisibility: Config.isDesktop(context),
        child: SingleChildScrollView(
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          scrollDirection: Axis.vertical,
          child: Container(
            alignment: Alignment.topCenter,
            color: Config.backgroundEdgeColor,
            child: SizedBox(
              width: Config.widePageWidth(context),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.all(Config.margin).add(
                      const EdgeInsets.symmetric(
                          horizontal: Config.margin * 2)),
                  child: SizedBox(
                      // height: Config.isDesktop(context) ? 60 : 40,
                      width: 500,
                      child: SearchField(
                        onChanged: handleSearch,
                        focusNode: searchFocusNode,
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: adViews,
                  ),
                ),
                const SizedBox(height: Config.margin),
                Wrap(children: recipeViews),
                const SizedBox(height: Config.margin),
                isLoadingMore
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox()
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void handleSearch(String string) {
    ServiceIO.showAlertDialog(
        "К сожалению, поиск сейчас не работает.", context);
  }
}
