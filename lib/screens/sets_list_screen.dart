import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/model/sets_info.dart';
import 'package:voice_recipe/components/recipe_collection_views/set_header_card.dart';
import 'package:voice_recipe/config.dart';

class SetsListScreen extends StatefulWidget {
  const SetsListScreen({super.key});

  static const route = "/collections";

  @override
  State<SetsListScreen> createState() => _SetsListScreen();
}

class _SetsListScreen extends State<SetsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Config.iconColor,
            backgroundColor: Config.appBarColor,
            title: const TitleLogoPanel(title: "Подборки")),
        body: Builder(
          builder: (context) => Container(
            color: Config.backgroundEdgeColor,
            alignment: Alignment.center,
            child: SizedBox(
              width: Config.maxRecipeSlideWidth,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Config.padding),
                itemCount: sets.length,
                itemBuilder: (_, index) => SetHeaderCard(
                    widthConstraint:
                        Config.pageWidth(context) > Config.pageHeight(context)
                            ? Config.maxRecipeSlideWidth
                            : 0,
                    set: sets[index],
                    onTap: () {}),
              ),
            ),
          ),
        ));
  }
}
