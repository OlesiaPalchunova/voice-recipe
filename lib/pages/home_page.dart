import 'package:flutter/material.dart';
import 'package:voice_recipe/components/advertisement.dart';
import 'package:voice_recipe/sidebar_menu/side_bar_menu.dart';
import 'package:voice_recipe/components/utils/slider_gesture_handler.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/components/search/search_field.dart';
import 'package:voice_recipe/config/config.dart';

import '../api/recipes_getter.dart';
import '../components/buttons/search_button.dart';
import '../services/BannerAdPage.dart';
import '../services/db/rate_db.dart';
import 'account/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({key});

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
  bool offline = false;
  bool isRecipeSearch = true;

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
      recipeViews.addAll(newPortion.map((e) => RecipeHeaderCard(recipe: e)).toList());
      // recipeViews.addAll(await Future.wait(newPortion.map((recipe) async {
      //   int mark = await RateDbManager().getMark(recipe.id, "lesia");
      //   return RecipeHeaderCard(recipe: recipe, mark: mark);
      // })));
    }
  }

  void showFoundRecipes(List<Recipe> recipes) {
    setState(() {
      recipeViews.addAll(recipes.map((e) => RecipeHeaderCard(recipe: e)).toList());
    });
  }

  void initRecipeViews() async {
    try {
      List<Recipe>? mainPage =
          await RecipesGetter().getCollection(collectionName, currentPage++);
      if (mainPage != null) {
        recipes.addAll(mainPage);
      }
      adViews.add(const Advertisement());
      recipeViews.addAll(recipes.map((e) => RecipeHeaderCard(recipe: e)).toList());
      if (!disposed) {
        setState(() {
          offline = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        offline = true;
      });
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
              backgroundColor: Config.backgroundEdgeColor,
              drawer: const SideBarMenu(),
              bottomNavigationBar: BottomBannerAd(),
              body: SafeArea(
                child: Builder(
                    builder: !offline ? buildMainContent : buildOffline),
              ));
        });
  }

  Widget buildOffline(BuildContext context) {
    String message = "К сожалению, не удалось загрузить рецепты :C\n"
        "Проверьте соединение с интернетом";
    return Center(
        child: Container(
      alignment: Alignment.center,
      width: Config.loginPageWidth(context),
      padding: Config.paddingAll,
      child: Column(
        children: [
          Container(
              height: 400,
              alignment: Alignment.center,
              child: LoginPage.voiceRecipeIcon(context, 500, 200)),
          Text(
            message,
            style: TextStyle(
                color: Config.darkModeOn ? Colors.white : Colors.black,
                fontSize: Config.isDesktop(context) ? 22 : 20,
                fontFamily: Config.fontFamily),
          )
        ],
      ),
    ));
  }

  double iconSize(BuildContext context) => Config.isDesktop(context) ? 30 : 15;

  Widget buildMainContent(BuildContext context) {
    return Scrollbar(
      thickness: Config.isDesktop(context) ? 20 : 0,
      radius: const Radius.elliptical(6, 12),
      controller: scrollController,
      interactive: true,
      thumbVisibility: Config.isDesktop(context),
      child: SingleChildScrollView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        physics: RangeMaintainingScrollPhysics(),
        child: Container(
          alignment: Alignment.topCenter,
          color: Config.backgroundEdgeColor,
          child: SizedBox(
            width: Config.widePageWidth(context),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(Config.margin).add(
                    const EdgeInsets.symmetric(horizontal: Config.margin * 2)),
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 280,
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: (){
                                    setState(() {
                                      isRecipeSearch = true;
                                    });
                                  },
                                  child: Text(
                                      "Поиск рецепта",
                                    style: TextStyle(
                                      color: Colors.black
                                    )
                                  )
                              ),
                              Text("|"),
                              TextButton(
                                  onPressed: (){
                                    setState(() {
                                      isRecipeSearch = false;
                                    });
                                  },
                                  child: Text(
                                      "Поиск коллекции",
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Config.isDesktop(context) ? 50 : 40,
                        width: 600,
                        child: SearchButton(
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierColor: Colors.transparent,
                                useSafeArea: false,
                                barrierDismissible: true,
                                builder: (context) => AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    // contentPadding: Config.zeroPadding,
                                    insetPadding: EdgeInsets.zero,
                                    elevation: 0,
                                    title: const SizedBox(
                                      height: Config.padding * 3.5,
                                    ),
                                    alignment: Alignment.topCenter,
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 80.0),
                                      child: SearchField(focusNode: FocusNode(), isRecipeSearch: isRecipeSearch),
                                    ),
                                )
                            );
                          },
                          text: isRecipeSearch ? 'Найти рецепт' : 'Найти коллекцию',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliderGestureHandler(
                handleKeyboard: false,
                ignoreVerticalSwipes: false,
                handleSideTaps: false,
                // customOnTap: () => searchFocusNode.unfocus(),
                onRight: () {},
                onEscape: () {},
                onLeft: () => Scaffold.of(context).openDrawer(),
                child: Column(
                  children: [
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
                  ],
                ),
              )
            ]
                // Container(
                //   alignment: Alignment.center,
                //   margin: const EdgeInsets.all(Config.margin).add(
                //       const EdgeInsets.symmetric(
                //           horizontal: Config.margin * 2)),
                //   child: SizedBox(
                //     // height: Config.isDesktop(context) ? 60 : 40,
                //       width: 500,
                //       child: SearchField(
                //         focusNode: searchFocusNode,
                //         updateRecipes: showFoundRecipes,
                //       )),
                // ),
                ),
          ),
        ),
      ),
    );
  }
}
