import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/components/timer_view.dart';

class RecipeStepView extends StatelessWidget {
  RecipeStepView({Key? key, required this.recipe, required this.slideId})
      : super(key: key) {
    int len = getStepsCount(recipe.id);
    int idx = min(slideId - 2, len - 1);
    step = getStep(recipe.id, idx);
  }

  static const _imageSize = 0.65;
  static const _borderRadius = 16.0;
  static const _textBackgroundOpacity = 0.75;
  static const _textSize = 0.022;

  final Recipe recipe;
  final int slideId;
  late final RecipeStep step;

  double _getImageHeight(BuildContext context) {
    var timerCoefficient = 1.0;
    if (step.waitTime != 0) {
      timerCoefficient = 0.85;
    }
    if (step.description.length >= 140) {
      return Config.pageHeight(context) *
          RecipeStepView._imageSize *
          0.9 *
          timerCoefficient;
    }
    return Config.pageHeight(context) *
        RecipeStepView._imageSize *
        timerCoefficient;
  }

  Widget _buildTimer() {
    if (step.waitTime == 0) {
      return Container();
    }
    int timerId = slideId + recipe.id * 100;
    return TimerView(
      key: Key("$timerId"),
      waitTimeMins: step.waitTime,
      id: timerId,
      alarmText: "${recipe.name}: шаг ${slideId - 1}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Config.padding),
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: _getImageHeight(context),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(RecipeStepView._borderRadius),
                    child: Image(
                      image: AssetImage(step.imgUrl),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.symmetric(
                        vertical: Config.margin, horizontal: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: !Config.darkModeOn ? Colors.black87
                              .withOpacity(RecipeStepView._textBackgroundOpacity)
                                  : Config.iconBackColor(),
                          borderRadius:
                              BorderRadius.circular(RecipeStepView._borderRadius)),
                      // height: 120,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(Config.padding),
                      child: Text(
                        step.description,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: Config.pageHeight(context) *
                                RecipeStepView._textSize,
                            color: Colors.white),
                      ),
                    )
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, Config.margin),
                  child: _buildTimer(),
                )
              ],
            ),
          ],
        ));
  }
}
