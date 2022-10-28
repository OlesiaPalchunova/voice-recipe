import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/util.dart';

class RecipeFace extends StatelessWidget {
  const RecipeFace({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const _centerOpacity = 0.4;
  static const _gradSize = 0.1;
  static const _betweenTextSize = 0.1;
  static const _betweenIconAndTextSize = 0.01;
  static const _iconSize = 0.03;
  static const _timeSize = 0.025;
  static const _nameSize = 0.055;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(recipe.faceImageUrl),
              fit: BoxFit.fitHeight,
            ),
            color: Colors.orangeAccent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Container(
                  height: Util.pageHeight(context) * _gradSize,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Colors.black87.withOpacity(_centerOpacity),
                        Colors.black87.withOpacity(0.0),
                      ])),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.black87.withOpacity(_centerOpacity),
                    padding: const EdgeInsets.all(Util.padding),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: Util.pageHeight(context) * _betweenTextSize,
                        ),
                        Row(children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: Util.pageHeight(context) * _iconSize,
                          ),
                          SizedBox(
                            width: Util.pageHeight(context) *
                                _betweenIconAndTextSize,
                          ),
                          Container(
                            height: Util.pageHeight(context) * _iconSize,
                            alignment: Alignment.centerLeft,
                            child: Text("${recipe.cookTimeMins} минут\n",
                                style: TextStyle(
                                    fontFamily: "MontserratBold",
                                    fontSize:
                                        Util.pageHeight(context) * _timeSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )
                        ]),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontFamily: "MontserratBold",
                                    fontSize:
                                        Util.pageHeight(context) * _nameSize,
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
                  height: Util.pageHeight(context) * _gradSize,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.black87.withOpacity(_centerOpacity),
                        Colors.black87.withOpacity(0.0),
                      ])),
                ),
              ],
            ),
            Container()
          ],
        ));
  }
}
