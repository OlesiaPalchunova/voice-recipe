import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/sidebar_menu/side_bar_menu.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/config.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _recipes = recipes;
  late var recipeViews = _recipes.map((e) => RecipeHeaderCard(recipe: e)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config.appBarColor(),
          title: const TitleLogoPanel(title: "Voice Recipe"),
        ),
        drawer: SideBarMenu(onUpdate: () => setState(() {})),
        body: Builder(
          builder: (context) => SliderGestureHandler(
            handleTaps: false,
            ignoreVerticalSwipes: false,
            onRight: () {},
            onLeft: () => Scaffold.of(context).openDrawer(),
            child: Container(
              alignment: Alignment.topCenter,
              color: Config.backgroundColor(),
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
                  Wrap(children: recipeViews)
                ]),
              ),
            ),
          ),
        )
    );
  }

  Widget buildSearchField() {
    final color = Config.iconColor();
    return TextField(
      style: TextStyle(color: color, fontFamily: Config.fontFamily),
      onChanged: (String string) {
        setState(() {
          _recipes = recipes
              .where((element) =>
                  element.name.toLowerCase().startsWith(string.toLowerCase()))
              .toList();
          recipeViews = _recipes.map((e) => RecipeHeaderCard(recipe: e)).toList();
        });
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Поиск',
        hintStyle: TextStyle(color: color, fontFamily: Config.fontFamily),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
