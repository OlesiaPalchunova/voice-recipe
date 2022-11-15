import 'package:flutter/material.dart';

import 'package:voice_recipe/model/sets_info.dart';
import '../components/recipe_header_card.dart';
import '../config.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key,
    required this.setOption,
  });

  final SetOption setOption;

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  late final recipes = widget.setOption.getRecipes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config.appBarColor(),
          title: Text(
            widget.setOption.name,
            style: const TextStyle(
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
        body: Builder(
            builder: (context) => Container(
              alignment: Alignment.topCenter,
                color: Config.backgroundColor(),
                child: Container(
                  margin: const EdgeInsets.only(top: Config.margin / 2),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: recipes.map((e) => RecipeHeaderCard(
                          recipe: e,
                          width: Config.pageWidth(context) * 0.45,
                          fontResizer: 1.5,)).toList()
                    ),
                  ),
                )
              ),
            )
    );
  }
}
