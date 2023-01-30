import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/timer/timer_view.dart';

class RecipeStepView extends StatelessWidget {
  RecipeStepView({Key? key, required this.recipe, required this.slideId})
      : super(key: key) {
    int len = recipe.steps.length;
    int idx = min(slideId - 2, len - 1);
    step = recipe.steps[idx];
  }

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
          .55 * timerCoefficient;
    }
    return Config.pageHeight(context) *
        .65 * timerCoefficient;
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

  double fontSize(BuildContext ctx) => Config.isDesktop(ctx) ? 18 : 18;

  Widget centerWidget(BuildContext context) {
    double height = _getImageHeight(context);
    double iconSize = Config.isDesktop(context) ? 300 : 200;
    return step.hasImage
        ? SizedBox(
            height: height,
            child: ClipRRect(
              borderRadius: Config.borderRadiusLarge,
              child: Image(
                image: NetworkImage(step.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Center(
          child: SizedBox(
            height: Config.isDesktop(context) ? 500 : 300,
            child: SizedBox(
              height: iconSize,
              width: iconSize,
              child: Image.asset("assets/images/voice_recipe.png"),
            ),
          ),
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
                centerWidget(context),
                Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.symmetric(
                        vertical: Config.margin, horizontal: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: !Config.darkModeOn
                              ? Colors.black87.withOpacity(.75)
                              : Config.iconBackColor,
                          borderRadius: Config.borderRadiusLarge),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(Config.padding),
                      child: SelectableText.rich(
                        TextSpan(
                          text: 'Шаг  ${slideId - 1}. ',
                          style: TextStyle(
                            fontFamily: Config.fontFamilyBold,
                            fontSize: fontSize(context),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: step.description, style: TextStyle(
                                fontFamily: Config.fontFamily,
                                fontSize: fontSize(context),
                                color: Colors.white,
                                fontWeight: FontWeight.normal
                            ))
                          ],
                        ),
                      )
                    )),
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
