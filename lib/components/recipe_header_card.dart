import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/components/buttons/favorites_button.dart';
import 'package:voice_recipe/components/review_views/rate_label.dart';
import 'package:voice_recipe/pages/recipe/future_recipe_page.dart';
import 'package:voice_recipe/services/db/category_db.dart';
import 'package:voice_recipe/services/db/rate_db.dart';

import '../model/category_model.dart';
import '../model/dialog/category_choice.dart';
import '../model/recipes_info.dart';
import 'package:voice_recipe/config/config.dart';

import '../model/sets_info.dart';
import '../pages/home_page.dart';
import 'labels/time_label.dart';

class RecipeHeaderCard extends StatefulWidget {
  const RecipeHeaderCard(
      {Key? key,
      required this.recipe,
        this.isSaved = false,
        this.collectionId = -1,
      // required this.mark,
      this.sizeDivider = 1,
      this.showLike = true,
        this.showCategories = false,})
      : super(key: key);

  final Recipe recipe;
  final bool isSaved;
  final int collectionId;
  // final int mark;
  final double sizeDivider;
  final bool showLike;
  final bool showCategories;
  static const maxDesktopHeight = 270.0;

  static double cardWidth(BuildContext context) {
    bool isDesktop = Config.pageWidth(context) >= Config.pageHeight(context);
    double height =
        isDesktop ? maxDesktopHeight : Config.pageHeight(context) * .3;
    var largeWidth = Config.pageWidth(context) * .9;
    var smallWidth = height * 1.2;
    double width = 0.0;
    if (isDesktop) {
      if (largeWidth < 2 * smallWidth) {
        width = largeWidth;
      } else {
        width = smallWidth;
      }
    } else {
      width = largeWidth;
    }
    return width;
  }

  static Future delete(BuildContext context, int category_id) async {
    final state = context.findAncestorStateOfType<_RecipeHeaderCardState>();
    if (state != null) {
      await state.delete(category_id);
    }
  }

  @override
  State<RecipeHeaderCard> createState() => _RecipeHeaderCardState();
}

class _RecipeHeaderCardState extends State<RecipeHeaderCard> {
  var pressed = false;
  var hovered = false;
  late double height;
  late double width;
  static double mark = 0.0;
  List<CategoryModel> categories = [];
  Map<int, Collection> allCategories = {};

  // Future getCategories() async {
  //   allCategories = await CategoryDB().getCategories();
  //   setState(() {
  //     for (var c in categories) {
  //       print(c.id);
  //       if (allCategories.containsKey(c.id)) allCategories.remove(c.id);
  //     }
  //   });
  // }

  Future initMark() async{
    double mark1 = await RateDbManager().getMark(widget.recipe.id);
    setState(() {
      RateDbManager.mark = mark1;
    });
  }

  Future initCategories() async {
    print(8888);
    var categories_temp = await CategoryDB().getCategoriesOfRecipe(widget.recipe.id);
    allCategories = await CategoryDB().getCategories();
    setState(() {
      categories = categories_temp;

      for (var c in categories) {
        print(c.id);
        if (allCategories.containsKey(c.id)) allCategories.remove(c.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // RateDbManager.mark = widget.recipe.mark;
    initMark();
    if (widget.showCategories) {
      initCategories();
      // getCategories();
    }

    print("=================");
    print(widget.collectionId);
    print(widget.recipe.faceImageUrl);
  }

  Future delete(int category_id) async {
    await CategoryDB().deleteRecipeFromCategory(
      recipe_id: widget.recipe.id,
      category_id: category_id,
    );
    initCategories();
    print(888);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = Config.isDesktop(context)
        ? RecipeHeaderCard.maxDesktopHeight
        : Config.pageHeight(context) * .3;
    var largeWidth = Config.pageWidth(context) * .9;
    var smallWidth = height * 1.2;
    if (Config.isDesktop(context)) {
      if (largeWidth < 2 * smallWidth) {
        width = largeWidth;
      } else {
        width = smallWidth;
      }
    } else {
      width = largeWidth;
    }
  }
  // var rate =  RateDbManager().addNewMark()

  bool get active => hovered || pressed;

  double get labelWidth => 60;

  Widget get rateLabel => RateLabel(
        rate: (widget.recipe.mark * 10).round()/10,
        // rate: RateDbManager().addNewMark(
        //
        // ),
        width: labelWidth,
      );

  Widget get favButton => FavoritesButton(
        recipeId: widget.recipe.id, isSaved: widget.isSaved, collectionId: widget.collectionId,
      );

  void onTap() async {
    setState(() {
      pressed = true;
    });
    await Future.delayed(Config.animationTime).whenComplete(() {
      setState(() {
        pressed = false;
        hovered = false;
      });
      navigateToRecipe(context, widget.recipe);
    });
  }

  double get spreadRadius => Config.darkModeOn ? 1 : 1;

  double get blurRadius => 6;

  double fontSize(BuildContext context) => Config.isDesktop(context) ? 20 : 18;

  double get nameShrinker {
    return .65;
  }

  Widget recipeHeader(double cardWidth) {
    if (widget.sizeDivider == 1 &&
        widget.recipe.name.length < 50 &&
        widget.recipe.cookTimeMins <= 60) {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: cardWidth * nameShrinker,
            child: Text(
              widget.recipe.name,
              style: TextStyle(
                  fontFamily: Config.fontFamily,
                  fontSize: fontSize(context),
                  color: Config.iconColor),
            ),
          ),
          TimeLabel(
            time: TimeLabel.convertToTOD(widget.recipe.cookTimeMins),
          ),
          // IconButton(onPressed: (){}, icon: Icon(Icons.add_box))
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.recipe.name,
          style: TextStyle(
              fontFamily: Config.fontFamily,
              fontSize: fontSize(context),
              color: Config.iconColor),
        ),
        const SizedBox(height: Config.margin / 2),
        TimeLabel(
          time: TimeLabel.convertToTOD(widget.recipe.cookTimeMins),
        )
      ],
    );
  }


  Future<bool?> showCategories(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryChoice(recipe_id: widget.recipe.id, allCategories: allCategories, categories: [],);
      },
    );
    print(444444444);
    initCategories();
  }


  @override
  Widget build(BuildContext context) {
    var cardWidth = width;
    var cardHeight = height;
    var smallCards = false;
    if (!Config.isDesktop(context) && widget.sizeDivider != 1) {
      smallCards = true;
      cardWidth = cardWidth / widget.sizeDivider;
      cardHeight = cardWidth;
    }
    return ValueListenableBuilder(
        valueListenable: Config.darkThemeProvider,
        builder: (context, darkModeOn, child) {
          return InkWell(
              onHover: (h) {
                setState(() {
                  hovered = h;
                });
              },
              onTap: onTap,
              child: Card(
                  color: Colors.transparent,
                  elevation: 7,
                  shape: const RoundedRectangleBorder(
                    borderRadius: Config.borderRadiusLarge,
                    //set border radius more than 50% of height and width to make circle
                  ),
                  shadowColor: Config.darkModeOn ? Colors.grey.shade500 : Colors.black87,
                  margin: EdgeInsets.all(
                      smallCards ? Config.margin / 2 : Config.margin),
                  child: AnimatedContainer(
                      onEnd: () {
                        setState(() {
                          pressed = false;
                        });
                      },
                      duration: Config.shortAnimationTime,
                      decoration: BoxDecoration(
                          color: active
                              ? Config.activeBackgroundLightedColor
                              : Config.edgeColor,
                          borderRadius: Config.borderRadiusLarge),
                      child: Column(children: [
                        Container(
                            width: cardWidth,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(Config.largeRadius))),
                            padding: Config.isDesktop(context)
                                ? Config.paddingAll.add(Config.paddingVert)
                                : Config.paddingAll,
                            child: recipeHeader(cardWidth)),
                        Stack(children: [
                          Container(
                              height: cardHeight,
                              width: cardWidth,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(Config.largeRadius)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.recipe.faceImageUrl),
                                      fit: BoxFit.cover))),
                          Positioned(
                              bottom: Config.margin,
                              left: Config.margin,
                              child: rateLabel),
                          Positioned(
                              bottom: Config.margin,
                              right: Config.margin,
                              child: widget.showLike
                                  ? favButton
                                  : const SizedBox()),
                          // Positioned(
                          //     bottom: Config.margin,
                          //     right: Config.margin,
                          //     child: IconButton(onPressed: (){}, icon: Icon(Icons.add_box)))

                        ]),
                        widget.showCategories ?
                        Container(
                          width: cardWidth,
                          // height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                spacing: 0.0,  // Расстояние между элементами по горизонтали.
                                runSpacing: 0.0,  // Расстояние между строками.
                                children: [
                                  for (var category in categories) category,

                                ],
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                    onPressed: () async {
                                      print(categories.length);
                                      var result = await showCategories(context);
                                      // await initCategories();

                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Icon(Icons.add_box),
                                    )
                                ),
                              )
                            ],
                          )
                        ) : Container(width: 100,)
                      ]))));
        });
  }

  void navigateToRecipe(BuildContext context, Recipe recipe) {
    String route = FutureRecipePage.route + recipe.id.toString();
    print("route: $route");
    String currentRoute = Routemaster.of(context).currentRoute.fullPath;
    print("route: $route");
    // if (currentRoute != HomePage.route) {
    //   route = '$currentRoute/recipe/${recipe.id}';
    // }
    print(route);
    Routemaster.of(context).push(route);
  }
}
