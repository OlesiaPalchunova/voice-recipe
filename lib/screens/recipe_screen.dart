import 'package:flutter/material.dart';

import 'package:voice_recipe/components/commands_listener.dart';
import 'package:voice_recipe/components/slides/recipe_face.dart';
import 'package:voice_recipe/components/slides/recipe_ingredients.dart';
import 'package:voice_recipe/components/slides/recipe_step_view.dart';
import 'package:voice_recipe/components/voice_commands/close_command.dart';
import 'package:voice_recipe/components/voice_commands/command.dart';
import 'package:voice_recipe/components/voice_commands/next_command.dart';
import 'package:voice_recipe/components/voice_commands/say_command.dart';
import 'package:voice_recipe/components/voice_commands/start_command.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';
import 'package:voice_recipe/components/util.dart';

import '../components/voice_commands/prev_command.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  late final RecipeIngredients ingPage = RecipeIngredients(recipe: recipe);
  late final RecipeFace facePage = RecipeFace(recipe: recipe);
  static const minSlideChangeDelayMillis = 100;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  static const firstStepSlideId = 2;
  int _slideId = 0;
  var lastSwipeTime = DateTime.now();
  late CommandsListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = CommandsListener(
      commandsList: <Command>[
        NextCommand(onTriggerFunction: () => setState(() {
          _incrementSlideId();
        })),
        BackCommand(onTriggerFunction: () => setState(() {
          _decrementSlideId();
        })),
        SayCommand(onTriggerFunction: () => RecipeStepViewState.sayCurrent()),
        StartCommand(onTriggerFunction: () => setState(() {
          _slideId = firstStepSlideId;
        })),
        CloseCommand(onTriggerFunction: () => _onClose(context)),
      ]
    );
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

  Widget _getSlide(BuildContext context, int slideId) {
    if (slideId == 0) {
      return RecipeFace(
        recipe: widget.recipe,
      );
    } else if (slideId == 1) {
      return RecipeIngredients(recipe: widget.recipe);
    }
    return RecipeStepView(
      recipe: widget.recipe,
      slideId: slideId,
    );
  }

  void _tapHandler(TapDownDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    final x = localOffset.dx;
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
      setState(() {
        _decrementSlideId();
      });
    }
    if (details.delta.dx < sensitivity) {
      setState(() {
        _incrementSlideId();
      });
    }
  }
}
