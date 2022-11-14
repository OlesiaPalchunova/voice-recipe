import 'package:flutter/material.dart';
import 'package:voice_recipe/components/sidebar_menu/side_bar_menu.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';
import 'package:voice_recipe/model/sets_info.dart';
import 'package:voice_recipe/components/set_header_card.dart';
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
          backgroundColor:
          Config.darkModeOn ? Colors.black87 : Config.colorScheme[80],
          title: const Text(
            "Подборки",
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
                  itemCount: sets.length,
                  itemBuilder: (_, index) =>
                      SetHeaderCard(set: sets[index]),
                ),
              ),
            )));
  }
}
