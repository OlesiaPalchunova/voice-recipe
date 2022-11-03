import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voice_recipe/components/notifications/say_notification.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';
import 'package:voice_recipe/components/util.dart';
import 'package:voice_recipe/components/timer.dart';
import 'package:voice_recipe/shared_data.dart';

class RecipeStepView extends StatefulWidget {
  RecipeStepView(
      {Key? key,
      required this.recipe,
      required this.slideId})
      : super(key: key) {
    int len = stepsResolve[recipe.id].length;
    int idx = min(slideId - 2, len - 1);
    step = stepsResolve[recipe.id][idx];
    tts.setLanguage("ru");
  }

  static final FlutterTts tts = FlutterTts();
  final Recipe recipe;
  final int slideId;
  late final RecipeStep step;

  static const _imageSize = 0.65;
  static const _borderRadius = 16.0;
  static const _textBackgroundOpacity = 0.75;
  static const _textSize = 0.022;

  @override
  State<RecipeStepView> createState() => RecipeStepViewState();
}

class RecipeStepViewState extends State<RecipeStepView> {
  var _isSaying = false;
  final Map<int, CookTimer> _cookTimers = SharedData.getCookTimers();
  static RecipeStepViewState? currentState;


  @override
  void initState() {
    super.initState();
    currentState = this;
    // RecipeStepView.tts.setCompletionHandler(() {
    //   setState(() {
    //     _isSaying = false;
    //   });
    // });
  }

  static bool sayCurrent() {
    if (currentState == null) return false;
    currentState!.say();
    return true;
  }

  void say() {
    setState(() {
      _isSaying = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    RecipeStepView.tts.stop();
  }

  double _getImageHeight() {
    var timerCoefficient = 1.0;
    if (widget.step.waitTime != 0) {
      timerCoefficient = 0.85;
    }
    if (widget.step.description.length >= 140) {
      return Util.pageHeight(context) *
          RecipeStepView._imageSize *
          0.9 *
          timerCoefficient;
    }
    return Util.pageHeight(context) *
        RecipeStepView._imageSize *
        timerCoefficient;
  }

  Widget _buildTimer() {
    if (widget.step.waitTime == 0) {
      return Container();
    }
    if (!_cookTimers.containsKey(widget.slideId)){
      _cookTimers[widget.slideId] = CookTimer(waitTimeMins: widget.step.waitTime,
        );
    }
    return _cookTimers[widget.slideId]!;
    // return CookTimer(waitTimeMins: widget.step.waitTime,
    //   slideId: widget.slideId,);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaying) {
      RecipeStepView.tts.speak(widget.step.description);
    }
    return NotificationListener<SayNotification>(
      onNotification: (SayNotification n) {
        if (!_isSaying) {
          setState(() {
            _isSaying = true;
          });
        }
        return true;
      },
      child: Container(
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
                      BorderRadius.circular(RecipeStepView._borderRadius),
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
                            .withOpacity(RecipeStepView._textBackgroundOpacity),
                        borderRadius: BorderRadius.circular(
                            RecipeStepView._borderRadius)),
                    // height: 120,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(Util.padding),
                    child: Text(
                      widget.step.description,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: Util.pageHeight(context) *
                              RecipeStepView._textSize,
                          color: Colors.white),
                    ),
                  )),
            ],
          )),
    );
  }

  IconButton _buildSayIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSaying = !_isSaying;
          });
          if (_isSaying) {
            RecipeStepView.tts.speak(widget.step.description);
          } else {
            RecipeStepView.tts.stop();
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
