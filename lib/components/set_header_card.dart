import 'package:flutter/material.dart';

import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/model/sets_info.dart';

import '../screens/set_screen.dart';

class SetHeaderCard extends StatelessWidget {
  const SetHeaderCard({
    Key? key,
    required this.set
  }) : super(key: key);

  final RecipesSet set;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToSet(context, set);
      },
      child: Card(
          color: Colors.white.withOpacity(0),
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 7),
          child: Stack(children: [
            SizedBox(
              height: Config.pageHeight(context) / 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Config.borderRadius),
                  gradient: const RadialGradient(
                    colors: [Colors.blueAccent, Color(0xff070707)],
                    radius: 1.9,
                    focal: Alignment.bottomCenter
                    // begin: Alignment.centerRight,
                    // end: Alignment.centerLeft
                  )
                ),
                child: Row(
                  children: [
                    SizedBox(width: Config.pageWidth(context) * 2 / 3,),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(Config.borderRadius),
                        child: Image(
                          image: AssetImage(set.imageUrl),
                          // fit: BoxFit.fitWidth,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(30, 35, 0, 50),
              child: Text(
                set.name,
                style: const TextStyle(
                    fontFamily: Config.fontFamilyBold,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ])),
    );
  }

  void _navigateToSet(BuildContext context, RecipesSet set) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SetScreen(set: set)));
  }
}
