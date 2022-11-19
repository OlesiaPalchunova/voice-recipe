import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/sidebar_menu/side_bar_menu.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/themes/theme_change_notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static var count = 0;
  var _recipes = recipes;
  late var recipeViews =
      _recipes.map((e) => RecipeHeaderCard(recipe: e)).toList();
  static const title = TitleLogoPanel(title: "Voice Recipe");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.black87.withOpacity(0.6),
        appBar: AppBar(
          foregroundColor: Config.iconColor,
          backgroundColor: Config.appBarColor,
          title: title,
        ),
        drawer: SideBarMenu(onUpdate: () {
          setState(() {
            TitleLogoPanelState.current?.update();
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
                    Wrap(children: recipeViews)
                  ]),
                ),
              ),
            ),
          ),
        ));
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
          recipeViews =
              _recipes.map((e) => RecipeHeaderCard(recipe: e)).toList();
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
