import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';

import '../components/recipe_header_card.dart';
import '../config.dart';
import '../model/recipes_info.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key,
    required this.recipes, required this.setName,
    this.showLikes = true
  });

  final List<Recipe> recipes;
  final String setName;
  final bool showLikes;

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  late final recipes = widget.recipes;
  late final isLaptopView = Config.pageWidth(context)
      > Config.pageHeight(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Config.iconColor,
          backgroundColor: Config.appBarColor,
          title: TitleLogoPanel(title: widget.setName),
        ),
        body: Builder(
            builder: (context) => Container(
              alignment: Alignment.topCenter,
                color: Config.backgroundEdgeColor,
                child: Container(
                  width: Config.maxPageWidth,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: Config.margin / 2),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: recipes.map((e) => RecipeHeaderCard(
                          recipe: e,
                          sizeDivider: 2,
                          showLike: widget.showLikes,
                      )
                      ).toList()
                    ),
                  ),
                )
              ),
            )
    );
  }
}
