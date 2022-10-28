import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voice_recipe/components/commands_listener.dart';

import 'package:voice_recipe/components/slides/recipe_face.dart';
import 'package:voice_recipe/components/slides/recipe_ingredients.dart';
import 'package:voice_recipe/components/slides/recipe_step.dart';

import 'package:voice_recipe/components/notifications/slide_notification.dart';
import 'package:voice_recipe/components/notifications/tts_notification.dart';

import 'package:voice_recipe/model/recipes_info.dart';

import '../components/header_panel.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key) {
    flutterTts.setLanguage("ru");
  }

  final Recipe recipe;
  final FlutterTts flutterTts = FlutterTts();
  static const minSlideChangeDelayMillis = 500;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _slideId = 0;
  var lastSwipeTime = DateTime.now();
  late CommandsListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = CommandsListener(
        onNext: () => setState(() {
              _incrementSlideId();
            }),
        onPrev: () => setState(() {
              _decrementSlideId();
            }));
    _listener.launchRecognition();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<TtsNotification>(
      onNotification: (TtsNotification ttsNotification) {
        int idx = ttsNotification.slideId - 2;
        RecipeStep step = stepsResolve[widget.recipe.id][idx];
        widget.flutterTts.speak(step.description);
        return true;
      },
      child: NotificationListener<SlideNotification>(
        onNotification: (SlideNotification slideNotification) {
          if (slideNotification.slideId == _slideId) {
            return false;
          }
          widget.flutterTts.stop();
          setState(() {
            _slideId = slideNotification.slideId;
          });
          return true;
        },
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            _tapHandler(details);
          },
          onPanUpdate: (details) {
            _swipeHandler(details);
          },
          child: Scaffold(
            body: Container(
              color: const Color(0xFFE9F7CA),
              child: Stack(
                children: [
                  Container(
                    height: 50,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: _getSlide(context, _slideId),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 55, horizontal: 10),
                      child: const HeaderPanel()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _decrementSlideId() {
    _slideId--;
    _slideId = _slideId < 0 ? 0 : _slideId;
  }

  void _incrementSlideId() {
    _slideId++;
    int max = stepsResolve[widget.recipe.id].length + 1;
    _slideId = _slideId > max ? max : _slideId;
  }

  Widget _getSlide(BuildContext context, int slideId) {
    SlideNotification(slideId: _slideId).dispatch(context);
    if (slideId == 0) {
      return RecipeFace(
        recipe: widget.recipe,
      );
    } else if (slideId == 1) {
      return RecipeIngredients(recipe: widget.recipe);
    }
    return RecipeStepWidget(recipe: widget.recipe, slideId: slideId);
  }

  void _tapHandler(TapDownDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    final x = localOffset.dx;
    widget.flutterTts.stop();
    if (x < box.size.width / 2) {
      setState(() {
        _decrementSlideId();
      });
    } else {
      setState(() {
        _incrementSlideId();
      });
    }
  }

  void _swipeHandler(DragUpdateDetails details) {
    int sensitivity = 0;
    var cur = DateTime.now();
    if (cur.difference(lastSwipeTime).inMilliseconds <= RecipeScreen.minSlideChangeDelayMillis) {
      return;
    }
    if (details.delta.dx != 0) {
      lastSwipeTime = cur;
    }
    if (details.delta.dx > sensitivity) {
      widget.flutterTts.stop();
      setState(() {
        _decrementSlideId();
      });
    }
    if (details.delta.dx < sensitivity) {
      widget.flutterTts.stop();
      setState(() {
        _incrementSlideId();
      });
    }
  }
}
