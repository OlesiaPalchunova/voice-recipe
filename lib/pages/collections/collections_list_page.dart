import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/model/sets_info.dart';
import 'package:voice_recipe/components/recipe_collection_views/collection_header_card.dart';
import 'package:voice_recipe/config.dart';

class CollectionsListPage extends StatefulWidget {
  const CollectionsListPage({super.key});

  static const route = "/collections";

  @override
  State<CollectionsListPage> createState() => _CollectionsListPage();
}

class _CollectionsListPage extends State<CollectionsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TitleLogoPanel(title: "Подборки").appBar(),
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
                itemBuilder: (_, index) => CollectionHeaderCard(
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
