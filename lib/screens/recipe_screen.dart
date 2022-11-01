import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voice_recipe/components/commands_listener.dart';
import 'package:voice_recipe/components/notifications/stt_notification.dart';

import 'package:voice_recipe/components/slides/recipe_face.dart';
import 'package:voice_recipe/components/slides/recipe_ingredients.dart';
import 'package:voice_recipe/components/slides/recipe_step.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';
import 'package:voice_recipe/components/util.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key) {
    flutterTts.setLanguage('ru');
  }

  final Recipe recipe;
  late final RecipeIngredients ingPage = RecipeIngredients(recipe: recipe);
  late final RecipeFace facePage = RecipeFace(recipe: recipe);
  final FlutterTts flutterTts = FlutterTts();

  static const minSlideChangeDelayMillis = 100;

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
        onStart: () => setState(() {
              _slideId = 2;
            }),
        onExit: () => _onClose(context),
        onNext: () => setState(() {
              _incrementSlideId();
            }),
        onPrev: () => setState(() {
              _decrementSlideId();
            }),
        onSay: () {
          _pronounce(_slideId);
        });
    _listener.start();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          _tapHandler(details);
        },
        onPanUpdate: (details) {
          _swipeHandler(details);
        },
        child: Scaffold(
          body: Container(
            color: Util.backColors[widget.recipe.id % Util.backColors.length],
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
                        vertical: 60, horizontal: 10),
                    child: HeaderPanel(
                      onClose: _onClose,
                      onList: _onList,
                      onMute: () => _listener.shutdown(),
                      onListen: () => _listener.start(),
                    )),
                Container(
                    alignment: Alignment.bottomCenter, child: sectionsPanel())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionsPanel() {
    var width = Util.pageWidth(context);
    var slidesCount = 2 + stepsResolve[widget.recipe.id].length;
    var sectionWidth = width / slidesCount;
    return Container(
      alignment: Alignment.center,
      height: 10,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: slidesCount,
        itemBuilder: (_, index) => Container(
          width: sectionWidth,
          color: index == _slideId ? Util.colors[widget.recipe.id % Util.colors.length]
              : Colors.black87,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    _onClose(context);
    return true;
  }

  void _onClose(BuildContext context) {
    _listener.shutdown();
    Navigator.of(context).pop();
  }

  void _onList() {
    setState(() {
      _slideId = 1;
    });
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

  void _pronounce(int slideId) {
    int idx = slideId - 2;
    var step = stepsResolve[widget.recipe.id][idx];
    widget.flutterTts.speak(step.description);
  }

  Widget _getSlide(BuildContext context, int slideId) {
    if (slideId == 0) {
      return RecipeFace(
        recipe: widget.recipe,
      );
    } else if (slideId == 1) {
      return RecipeIngredients(recipe: widget.recipe);
    }
    return RecipeStepWidget(
      recipe: widget.recipe,
      onSayButton: () => _pronounce(slideId),
      onStopButton: () => widget.flutterTts.stop(),
      slideId: slideId,
    );
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
    if (cur.difference(lastSwipeTime).inMilliseconds <=
        RecipeScreen.minSlideChangeDelayMillis) {
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
