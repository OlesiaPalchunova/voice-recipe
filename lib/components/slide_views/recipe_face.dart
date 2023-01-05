import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';

class RecipeFaceSlideView extends StatelessWidget {
  const RecipeFaceSlideView({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const _centerOpacity = 0.8;
  static const _gradSize = 0.1;
  static const _betweenTextSize = 0.1;
  static const _betweenIconAndTextSize = 0.01;
  static const _iconSize = 0.03;
  
  double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 30 : 28;
  double timeFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 20 : 18;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(Config.margin).add(
          const EdgeInsets.only(bottom: Config.margin)
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: Config.borderRadiusLarge,
            image: DecorationImage(
              image: recipe.isNetwork ?
              NetworkImage(recipe.faceImageUrl)
                  : AssetImage(recipe.faceImageUrl) as ImageProvider,
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
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Config.getBackColor(recipe.id).withOpacity(_centerOpacity),
                      boxShadow: Config.darkModeOn ? [] : [
                        BoxShadow(
                            color: Config.iconColor,
                            spreadRadius: 0.4
                          )
                      ]
                      // borderRadius: Config.borderRadiusLarge,
                    ),
                    padding: const EdgeInsets.all(Config.padding),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(children: [
                          Icon(
                            Icons.access_time,
                            color: Config.iconColor,
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
                                    fontFamily: Config.fontFamily,
                                    fontSize: timeFontSize(context),
                                    color: Config.iconColor)),
                          )
                        ]),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontFamily: Config.fontFamily,
                                    fontSize: titleFontSize(context),
                                    color: Config.iconColor),
                                children: <TextSpan>[
                                  TextSpan(text: recipe.name)
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container()
          ],
        ));
  }
}
