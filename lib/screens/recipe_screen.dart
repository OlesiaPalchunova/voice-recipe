import 'package:flutter/material.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';

import 'package:voice_recipe/model/commands_listener.dart';
import 'package:voice_recipe/components/slides/recipe_face.dart';
import 'package:voice_recipe/components/slides/recipe_ingredients.dart';
import 'package:voice_recipe/components/slides/recipe_step_view.dart';
import 'package:voice_recipe/components/timer_view.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_buttons_panel.dart';
import 'package:voice_recipe/util.dart';

import 'package:voice_recipe/model/voice_commands/close_command.dart';
import 'package:voice_recipe/model/voice_commands/command.dart';
import 'package:voice_recipe/model/voice_commands/next_command.dart';
import 'package:voice_recipe/model/voice_commands/reset_timer_command.dart';
import 'package:voice_recipe/model/voice_commands/say_command.dart';
import 'package:voice_recipe/model/voice_commands/start_command.dart';
import 'package:voice_recipe/model/voice_commands/prev_command.dart';
import 'package:voice_recipe/model/voice_commands/start_timer_command.dart';
import 'package:voice_recipe/model/voice_commands/stop_timer_command.dart';

import '../model/voice_commands/stop_say.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  late final IngredientsSlideView ingPage = IngredientsSlideView(recipe: recipe);
  late final RecipeFaceSlideView facePage = RecipeFaceSlideView(recipe: recipe);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  static const faceSlideId = 0;
  static const ingredientsSlideId = 1;
  static const firstStepSlideId = 2;
  int _slideId = 0;
  late CommandsListener _listener;

  @override
  void initState() {
    super.initState();
    _initCommandsListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SliderGestureHandler(
        onLeft: () => setState(() => _decrementSlideId()),
        onRight: () => setState(() => _incrementSlideId()),
        child: Scaffold(
          body: Container(
            color: Config.backColors[widget.recipe.id % Config.backColors.length],
            child: Stack(
              children: [
                Container(
                  height: 50,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: _buildCurrentSlide(context, _slideId),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 60, horizontal: 10),
                    child: HeaderButtonsPanel(
                      onClose: _onClose,
                      onList: () => setState(() {
                        _slideId = ingredientsSlideId;
                      }),
                      onMute: () => _listener.shutdown(),
                      onListen: () => _listener.start(),
                    )),
                Container(
                    alignment: Alignment.bottomCenter, child: _buildSliderBottom())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSlide(BuildContext context, int slideId) {
    if (slideId == faceSlideId) {
      return RecipeFaceSlideView(
        recipe: widget.recipe,
      );
    } else if (slideId == ingredientsSlideId) {
      return IngredientsSlideView(recipe: widget.recipe);
    }
    return RecipeStepView(
      recipe: widget.recipe,
      slideId: slideId,
    );
  }

  Widget _buildSliderBottom() {
    var width = Config.pageWidth(context);
    var slidesCount = 2 + getStepsCount(widget.recipe.id);
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
          color: index == _slideId ? Config.colors[widget.recipe.id % Config.colors.length]
              : Colors.black87,
        ),
      ),
    );
  }

  void _initCommandsListener() {
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
          StopSayCommand(onTriggerFunction: () => RecipeStepViewState.stopCurrent()),
          StartTimerCommand(onTriggerFunction: () {
            TimerViewState? state = TimerViewState.getCurrent();
            if (state != null) {
              state.startTimer();
            }
          }),
          StopTimerCommand(onTriggerFunction: () {
            TimerViewState? state = TimerViewState.getCurrent();
            if (state != null) {
              state.stopTimer();
            }
          }),
          ResetTimerCommand(onTriggerFunction: () {
            TimerViewState? state = TimerViewState.getCurrent();
            if (state != null) {
              state.resetTimer();
            }
          }),
        ]
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

  void _decrementSlideId() {
    _slideId--;
    _slideId = _slideId < 0 ? 0 : _slideId;
  }

  void _incrementSlideId() {
    _slideId++;
    int max = getStepsCount(widget.recipe.id) + 1;
    _slideId = _slideId > max ? max : _slideId;
  }
}
