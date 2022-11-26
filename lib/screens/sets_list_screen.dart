import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/model/sets_info.dart';
import 'package:voice_recipe/components/sets/set_header_card.dart';
import 'package:voice_recipe/config.dart';

class SetsListScreen extends StatefulWidget {
  const SetsListScreen({super.key});

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
            color: Config.backgroundColor,
            alignment: Alignment.center,
            child: SizedBox(
              width: Config.maxRecipeSlideWidth,
              child: ListView.separated(
                separatorBuilder: (_, index) => Divider(
                  color: Config.iconColor,
                  thickness: 0.2,
                ),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Config.padding),
                itemCount: sets.length,
                itemBuilder: (_, index) => SetHeaderCard(
                    parentWidth:
                        Config.pageWidth(context) > Config.pageHeight(context)
                            ? 700
                            : 0,
                    set: sets[index],
                    onTap: () {}),
              ),
            ),
          ),
        ));
  }
}
