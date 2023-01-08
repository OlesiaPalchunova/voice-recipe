import 'package:flutter/material.dart';
import 'package:voice_recipe/components/advertisement.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/sidebar_menu/side_bar_menu.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/config.dart';

import '../api/recipes_getter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const route = '/';

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  var _recipes = recipes;
  final List<RecipeHeaderCard> recipeViews = [];
  static const title = TitleLogoPanel(title: Config.appName);
  static HomeState? current;
  static const drawerScrimColor = Color.fromRGBO(17, 17, 17, .6);
  final List<Advertisement> ads = [];
  bool _disposed = false;

  @override
  void initState() {
    current = this;
    initRecipeViews();
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void initRecipeViews() async {
    if (_recipes.isEmpty) {
      var mainPage = await RecipesGetter().getCollection('mainpage');
      if (mainPage != null) {
        recipes.addAll(mainPage);
      }
      _recipes = recipes;
    }
    ads.clear();
    ads.add(Advertisement());
    recipeViews.clear();
    recipeViews.addAll(_recipes.map((e) => RecipeHeaderCard(recipe: e)).toList());
    if (!_disposed) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: drawerScrimColor,
        appBar: AppBar(
          foregroundColor: Config.iconColor,
          backgroundColor: Config.appBarColor,
          title: title,
        ),
        drawer: SideBarMenu(onUpdate: () {
          setState(() {
            TitleLogoPanelState.current?.update();
            initRecipeViews();
          });
        }),
        body: Builder(
          builder: (context) => SliderGestureHandler(
            handleTaps: false,
            ignoreVerticalSwipes: false,
            onRight: () {},
            onLeft: () => Scaffold.of(context).openDrawer(),
            child: Container(
              alignment: Alignment.topCenter,
              color: Config.backgroundColor,
              child: SizedBox(
                width: Config.pageWidth(context),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.all(Config.margin).add(
                          const EdgeInsets.symmetric(
                              horizontal: Config.margin * 2)),
                      child: SizedBox(width: 500, child: buildSearchField()),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: ads,
                      ),
                    ),
                    Wrap(children: recipeViews)
                  ]),
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget buildSearchField() {
    final color = Config.iconColor;
    return TextField(
      style: TextStyle(color: color, fontFamily: Config.fontFamily),
      onChanged: (String string) {
        setState(() {
          _recipes = recipes
              .where((element) =>
                  element.name.toLowerCase().startsWith(string.toLowerCase()))
              .toList();
          recipeViews.clear();
          recipeViews.addAll(_recipes.map((e) => RecipeHeaderCard(recipe: e)).toList());
        });
      },
      decoration: InputDecoration(
        contentPadding: Config.paddingAll,
        hintText: 'Поиск',
        hintStyle: TextStyle(color: color, fontFamily: Config.fontFamily),
        prefixIcon: Icon(Icons.search, color: color),
        enabledBorder: OutlineInputBorder(
          borderRadius: Config.borderRadiusLarge,
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Config.borderRadiusLarge,
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
