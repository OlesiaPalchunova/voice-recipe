import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';

class RecipeFaceSlideView extends StatelessWidget {
  const RecipeFaceSlideView({
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
        margin: const EdgeInsets.all(Config.margin).add(
          const EdgeInsets.only(bottom: Config.margin)
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
            image: DecorationImage(
              image: AssetImage(recipe.faceImageUrl),
              fit: Config.pageHeight(context) > Config.pageWidth(context)
                  ? BoxFit.fitHeight
                  : BoxFit.fitHeight,
            ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Container(
                  height: Config.pageHeight(context) * _gradSize,
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
                    padding: const EdgeInsets.all(Config.padding),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: Config.pageHeight(context) * _betweenTextSize,
                        ),
                        Row(children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: Config.pageHeight(context) * _iconSize,
                          ),
                          SizedBox(
                            width: Config.pageHeight(context) *
                                _betweenIconAndTextSize,
                          ),
                          Container(
                            height: Config.pageHeight(context) * _iconSize,
                            alignment: Alignment.centerLeft,
                            child: Text("${recipe.cookTimeMins} минут\n",
                                style: TextStyle(
                                    fontFamily: Config.fontFamilyBold,
                                    fontSize:
                                        Config.pageHeight(context) * _timeSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )
                        ]),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontFamily: Config.fontFamilyBold,
                                    fontSize:
                                        Config.pageHeight(context) * _nameSize,
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
                  height: Config.pageHeight(context) * _gradSize,
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
