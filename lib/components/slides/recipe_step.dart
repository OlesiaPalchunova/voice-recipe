import 'dart:math';

import 'package:flutter/material.dart';

import 'package:voice_recipe/components/notifications/tts_notification.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';
import 'package:voice_recipe/components/util.dart';

class RecipeStepWidget extends StatelessWidget {
  RecipeStepWidget({Key? key, required this.recipe, required this.slideId})
      : super(key: key) {
    int len = stepsResolve[recipe.id].length;
    int idx = min(slideId - 2, len - 1);
    step = stepsResolve[recipe.id][idx];
  }

  final Recipe recipe;
  final int slideId;
  late final RecipeStep step;

  static const _imageSize = 0.65;
  static const _borderRadius = 16.0;
  static const _textBackgroundOpacity = 0.75;
  static const _textSize = 0.022;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Util.padding),
        child: Column(
          children: [
            HeaderPanel.buildButton(
                context,
                IconButton(
                    onPressed: () => _pronounce(context),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.black87,
                    ))),
            Container(
              margin: const EdgeInsets.fromLTRB(0, Util.margin, 0, 0),
              height: Util.pageHeight(context) * _imageSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: Image(
                  image: AssetImage(step.imgUrl),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: Util.margin, horizontal: 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(_textBackgroundOpacity),
                      borderRadius: BorderRadius.circular(_borderRadius)),
                  // height: 120,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Util.padding),
                  child: Text(
                    step.description,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: Util.pageHeight(context) * _textSize,
                        color: Colors.white),
                  ),
                )),
          ],
        ));
  }

  void _pronounce(BuildContext context) {
    TtsNotification ttsNotification = TtsNotification(slideId: slideId);
    ttsNotification.dispatch(context);
  }
}
