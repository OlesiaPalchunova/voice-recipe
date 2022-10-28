import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/components/notifications/slide_notification.dart';

import 'package:voice_recipe/components/notifications/tts_notification.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';
import 'package:voice_recipe/components/util.dart';

class RecipeStepWidget extends StatefulWidget {
  RecipeStepWidget(
      {Key? key,
      required this.recipe,
      required this.onSayButton,
      required this.onStopButton, required int slideId})
      : super(key: key) {
    int len = stepsResolve[recipe.id].length;
    int idx = min(slideId - 2, len - 1);
    step = stepsResolve[recipe.id][idx];
  }

  final void Function() onSayButton;
  final void Function() onStopButton;
  final Recipe recipe;
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
  
  @override
  Widget build(BuildContext context) {
    if (_isSaying) {
      widget.onSayButton();
    }
    return Container(
        padding: const EdgeInsets.all(Util.padding),
        child: Column(
          children: [
            HeaderPanel.buildButton(
                context,
                IconButton(
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
                          ))),
            Container(
              margin: const EdgeInsets.fromLTRB(0, Util.margin, 0, 0),
              height: Util.pageHeight(context) * RecipeStepWidget._imageSize,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(RecipeStepWidget._borderRadius),
                child: Image(
                  image: AssetImage(widget.step.imgUrl),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
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
}
