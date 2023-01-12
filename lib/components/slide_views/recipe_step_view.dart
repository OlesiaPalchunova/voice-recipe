import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';
import 'package:voice_recipe/components/timer/timer_view.dart';

class RecipeStepView extends StatelessWidget {
  RecipeStepView({Key? key, required this.recipe, required this.slideId})
      : super(key: key) {
    int len = recipe.steps.length;
    int idx = min(slideId - 2, len - 1);
    step = recipe.steps[idx];
  }

  static const _imageSize = 0.65;
  static const _borderRadius = 16.0;
  static const _textBackgroundOpacity = 0.75;

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
      colorId: recipe.id,
      alarmText: "${recipe.name}: шаг ${slideId - 1}",
    );
  }

  double fontSize(BuildContext ctx) =>
      Config.isDesktop(ctx) ? 18 : 16;

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
                      image: recipe.isNetwork ?
                      NetworkImage(step.imgUrl)
                          : AssetImage(step.imgUrl) as ImageProvider,
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
                                  : Config.iconBackColor,
                          borderRadius: Config.borderRadiusLarge),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(Config.padding),
                      child: Text(
                        step.description,
                        style: TextStyle(
                            fontFamily: Config.fontFamily,
                            fontSize: fontSize(context),
                            color: Colors.white),
                      ),
                    )
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, Config.margin * 3),
                  child: _buildTimer(),
                )
              ],
            ),
          ],
        ));
  }
}
