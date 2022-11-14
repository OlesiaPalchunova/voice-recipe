import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Config.darkModeOn ? Colors.black87 : Config.colorScheme[80],
          title: const Text(
            "Voice Recipe",
            style: TextStyle(
                fontFamily: Config.fontFamilyBold,
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          centerTitle: true,
          leading: Container(
              padding: const EdgeInsets.all(5),
              child: Image.asset("assets/images/voice_recipe.png")),
        ),
        drawer: SideBarMenu(onUpdate: () => setState(() {})),
        body: Builder(
            builder: (context) => SliderGestureHandler(
                  handleTaps: false,
                  ignoreVerticalSwipes: false,
                  onRight: () {},
                  onLeft: () => Scaffold.of(context).openDrawer(),
                  child: Container(
                    color: Config.backgroundColor(),
                    child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          itemCount: recipes.length + 1,
                          itemBuilder: (_, index) {
                            if (index == 0) {
                              return Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, Config.margin),
                                  child: buildSearchField()
                              );
                            }
                            return RecipeHeaderCard(recipe: recipes[index - 1]);
                          },
                        ),
                  ),
                )));
  }

  Widget buildSearchField() {
    const color = Colors.white;
    return TextField(
      style: const TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Поиск',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
