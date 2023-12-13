import 'package:flutter/material.dart';
import '../../api/recipes_getter.dart';
import '../../components/recipe_header_card.dart';
import '../../config/config.dart';
import '../../model/recipes_info.dart';
import '../../services/BannerAdPage.dart';
import '../../services/db/rate_db.dart';

class SpecificCollectionPage extends StatefulWidget {
  const SpecificCollectionPage(
      {key,
        required this.recipes,
        this.collectionId = -1,
        this.showLikes = true,
        this.showCategories = false});

  final Map<int, Recipe>? recipes;
  final bool showLikes;
  final bool showCategories;
  final int collectionId;

  @override
  State<SpecificCollectionPage> createState() => _SpecificCollectionPageState();
}

class _SpecificCollectionPageState extends State<SpecificCollectionPage> {
  late final recipes = widget.recipes;
  final recipeCards = <RecipeHeaderCard>[];
  late final isLaptopView =
      Config.pageWidth(context) > Config.pageHeight(context);
  final scrollController = ScrollController();
  int lastShownIdx = 0;
  bool isLoadingMore = false;
  int currentPage = 1;
  int maxPage = 8;
  bool disposed = false;
  static const maxShownRecipes = 12;
  // int begin = 0;
  // late int end = recipes.length;

  // Future<void> scrollListener() async {
  //   if (isLoadingMore) return;
  //   if (currentPage >= maxPage) return;
  //   if (scrollController.position.pixels !=
  //       scrollController.position.maxScrollExtent) {
  //     return;
  //   }
  //   setState(() => isLoadingMore = true);
  //   await fetchNewRecipesPortion();
  //   if (disposed) return;
  //   setState(() => isLoadingMore = false);
  // }

  @override
  void initState() {
    super.initState();
    // const special = ['favorites', 'created'];
    // if (special.contains(widget.collectionName)) {
    //   currentPage = maxPage;
    // }
    recipeCards.addAll(recipes!.entries.map((entry) {
      int recipeId = entry.key;
      Recipe recipe = entry.value;
      return RecipeHeaderCard(recipe: recipe, isSaved: true, collectionId: widget.collectionId, showCategories: widget.showCategories,);
    }));

    // recipeCards.addAll(recipes.map((recipe) => RecipeHeaderCard(recipe: recipe)));
    // scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    disposed = true;
    scrollController.dispose();
    super.dispose();
  }

  // Future<void> fetchNewRecipesPortion() async {
  //   var newPortion = await RecipesGetter().getCollection(widget.collectionName, currentPage++);
  //   if (newPortion != null && newPortion.isNotEmpty) {
  //     end += newPortion.length;
  //     recipes.addAll(newPortion);
  //     recipeCards.addAll(newPortion.map((e) => RecipeHeaderCard(recipe: e)).toList());
  //   } else {
  //     currentPage = maxPage;
  //   }
  // }

  // Future<void> fetchNewRecipesPortion() async {
  //   var newPortion = await RecipesGetter().getCollection(widget.collectionName, currentPage++);
  //   if (newPortion != null && newPortion.isNotEmpty) {
  //     end += newPortion.length;
  //     recipes.addAll(newPortion);
  //     recipeCards.addAll(await Future.wait(newPortion.map((recipe) async {
  //       int mark = await RateDbManager().getMark(recipe.id, "lesia");
  //       return RecipeHeaderCard(recipe: recipe, mark: mark);
  //     })));
  //   } else {
  //     currentPage = maxPage;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Config.defaultAppBar,
        bottomNavigationBar: BottomBannerAd(),
        body: Builder(
          builder: (context) => Container(
              alignment: Alignment.topCenter,
              color: Config.backgroundEdgeColor,
              child: Container(
                  width: Config.maxPageWidth,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: Config.margin / 2),
                  child: Stack(children: [
                    Scrollbar(
                        thickness: Config.isDesktop(context) ? 20 : 0,
                        radius: const Radius.elliptical(6, 12),
                        controller: scrollController,
                        interactive: true,
                        thumbVisibility: Config.isDesktop(context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          child: Column(
                            children: [
                              Wrap(children: recipeCards),
                              const SizedBox(height: Config.margin),
                              isLoadingMore
                                  ? const Center(
                                  child: CircularProgressIndicator())
                                  : const SizedBox()
                            ],
                          ),
                        )),
                    recipes!.isEmpty
                        ? Center(
                        child: Text("Данная коллекция пока что пуста :/",
                            style: TextStyle(
                              fontSize: 18,
                              color: Config.iconColor,
                              fontFamily: Config.fontFamily,
                            )))
                        : const SizedBox()
                  ]))),
        ));
  }
}
