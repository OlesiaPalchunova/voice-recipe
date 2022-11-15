import 'dart:math';

import 'package:flutter/material.dart';
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
          backgroundColor: Config.appBarColor(),
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
        body: Builder(
          builder: (context) => Container(
            color: Config.backgroundColor(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Config.padding),
              itemCount: sets.length,
              itemBuilder: (_, index) => SetHeaderCard(
                set: sets[index],
                onTap: () {}
              ),
            ),
          ),
        )
    );
  }
}
