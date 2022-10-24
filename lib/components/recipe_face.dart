import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipe_header.dart';
import 'package:voice_recipe/components/header_panel.dart';

class RecipeFace extends StatelessWidget {
  const RecipeFace({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(recipe.faceImageUrl),
            fit: BoxFit.fitHeight,
          ),
          color: Colors.orangeAccent
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontFamily: "MontserratBold",
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                              text: "${recipe.cookTimeMins} минут\n",
                              style: const TextStyle(fontSize: 15)),
                          TextSpan(text: recipe.name)
                        ]),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.star_border),
            )
          ],
        ));
  }
}
