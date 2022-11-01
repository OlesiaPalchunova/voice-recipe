import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';
import 'package:voice_recipe/components/util.dart';
import 'package:voice_recipe/components/timer.dart';
import 'package:voice_recipe/shared_data.dart';

class RecipeStepWidget extends StatefulWidget {
  RecipeStepWidget(
      {Key? key,
      required this.recipe,
      required this.onSayButton,
      required this.onStopButton,
      required this.slideId})
      : super(key: key) {
    int len = stepsResolve[recipe.id].length;
    int idx = min(slideId - 2, len - 1);
    step = stepsResolve[recipe.id][idx];
  }

  final void Function() onSayButton;
  final void Function() onStopButton;
  final Recipe recipe;
  final int slideId;
  late final RecipeStep step;

  static const _imageSize = 0.65;
  static const _borderRadius = 16.0;
  static const _textBackgroundOpacity = 0.75;
  static const _textSize = 0.022;

  @override
  State<RecipeStepWidget> createState() => _RecipeStepWidgetState();
}

class _RecipeStepWidgetState extends State<RecipeStepWidget> {
  var _isSaying = false;
  final Map<int, CookTimer> _cookTimers = SharedData.getCookTimers();

  @override
  void initState() {
    super.initState();
  }

  double _getImageHeight() {
    var timerCoefficient = 1.0;
    if (widget.step.waitTime != 0) {
      timerCoefficient = 0.85;
    }
    if (widget.step.description.length >= 140) {
      return Util.pageHeight(context) *
          RecipeStepWidget._imageSize *
          0.9 *
          timerCoefficient;
    }
    return Util.pageHeight(context) *
        RecipeStepWidget._imageSize *
        timerCoefficient;
  }

  Widget _buildTimer() {
    if (widget.step.waitTime == 0) {
      return Container();
    }
    if (_cookTimers.containsKey(widget.slideId)){
      return _cookTimers[widget.slideId]!;
    } else {
      _cookTimers[widget.slideId] = CookTimer(waitTimeMins: widget.step.waitTime);
    }
    return _cookTimers[widget.slideId]!;
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaying) {
      widget.onSayButton();
    }
    return Container(
        padding: const EdgeInsets.all(Util.padding),
        child: Column(
          children: [
            HeaderPanel.buildButton(context, _buildSayIcon(),
                !_isSaying ? Colors.white : Colors.white54),
            Container(
              margin: const EdgeInsets.fromLTRB(0, Util.margin, 0, 0),
              height: _getImageHeight(),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(RecipeStepWidget._borderRadius),
                child: Image(
                  image: AssetImage(widget.step.imgUrl),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            _buildTimer(),
            Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(
                    vertical: Util.margin, horizontal: 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black87
                          .withOpacity(RecipeStepWidget._textBackgroundOpacity),
                      borderRadius: BorderRadius.circular(
                          RecipeStepWidget._borderRadius)),
                  // height: 120,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Util.padding),
                  child: Text(
                    widget.step.description,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: Util.pageHeight(context) *
                            RecipeStepWidget._textSize,
                        color: Colors.white),
                  ),
                )),
          ],
        ));
  }

  IconButton _buildSayIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSaying = !_isSaying;
          });
          if (_isSaying) {
            widget.onSayButton();
          } else {
            widget.onStopButton();
          }
        },
        icon: _isSaying
            ? const Icon(
                Icons.pause,
                color: Colors.black87,
              )
            : const Icon(
                Icons.play_arrow,
                color: Colors.black87,
              ));
  }
}
