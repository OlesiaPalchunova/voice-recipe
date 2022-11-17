import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';

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
  late final isLaptopView = Config.pageWidth(context)
      > Config.pageHeight(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config.appBarColor(),
          title: TitleLogoPanel(title: widget.setOption.name),
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
                          fontResizer: isLaptopView ? 1 : 1.5,)).toList()
                    ),
                  ),
                )
              ),
            )
    );
  }
}