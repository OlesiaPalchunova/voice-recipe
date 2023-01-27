import 'package:flutter/material.dart';
import 'package:voice_recipe/components/labels/time_label.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';

class RecipeFaceSlideView extends StatelessWidget {
  const RecipeFaceSlideView({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const _gradSize = 0.1;
  static const _betweenTextSize = 0.1;
  static const _betweenIconAndTextSize = 0.01;
  static const _iconSize = 0.03;

  double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 26 : 24;

  double timeFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 20 : 18;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(Config.margin)
            .add(const EdgeInsets.only(bottom: Config.margin)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge,
          image: DecorationImage(
            image: NetworkImage(recipe.faceImageUrl),
            fit: BoxFit.cover,
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
                      color: Config.getBackColor(recipe.id).withOpacity(.8),
                    ),
                    padding: const EdgeInsets.all(Config.padding),
                    width: double.infinity,
                    child: Column(
                      children: [
                        TimeLabel(
                          time: TimeLabel.convertToTOD(recipe.cookTimeMins),
                          iconSize: 24,
                          customFontSize: timeFontSize(context),
                        ),
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
