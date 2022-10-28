import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black87.withOpacity(0.4),
                            Colors.black87.withOpacity(0.0),
                          ])),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.black87.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(
                                Icons.access_time,
                              color: Colors.white,
                              size: 20,
                            ),
                            Container(
                              height: 16,
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text("${recipe.cookTimeMins} минут\n",
                                  style: const TextStyle(fontFamily: "MontserratBold",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )
                          ]
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontFamily: "MontserratBold",
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(text: recipe.name)
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black87.withOpacity(0.4),
                            Colors.black87.withOpacity(0.0),
                          ])),
                ),
              ],
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
