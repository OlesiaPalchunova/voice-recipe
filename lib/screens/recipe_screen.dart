import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voice_recipe/components/buttons/listen_button.dart';
import 'package:voice_recipe/components/buttons/say_button.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';

import 'package:voice_recipe/model/commands_listener.dart';
import 'package:voice_recipe/components/slides/recipe_face.dart';
import 'package:voice_recipe/components/slides/recipe_ingredients.dart';
import 'package:voice_recipe/components/slides/recipe_step_view.dart';
import 'package:voice_recipe/components/timer_view.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_buttons_panel.dart';
import 'package:voice_recipe/config.dart';

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
  }) : super(key: key) {
    tts.setLanguage("ru");
  }

  final Recipe recipe;
  static final FlutterTts tts = FlutterTts();
  late final IngredientsSlideView ingPage = IngredientsSlideView(recipe: recipe);
  late final RecipeFaceSlideView facePage = RecipeFaceSlideView(recipe: recipe);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  static const faceSlideId = 0;
  static const ingredientsSlideId = 1;
  static const firstStepSlideId = 2;
  static int _slideId = 0;
  late CommandsListener _listener;

  @override
  void initState() {
    super.initState();
    _initCommandsListener();
  }

  @override
  void dispose() {
    super.dispose();
    RecipeScreen.tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SliderGestureHandler(
        onLeft: _onPrev,
        onRight: _onNext,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 60,
            backgroundColor: Config.backgroundColor(),
            title: HeaderButtonsPanel(
              backColor: Config.backgroundColor(),
              id: widget.recipe.id,
              onClose: _onClose,
              onList: () => setState(() {
                _slideId = ingredientsSlideId;
              }),
              onMute: () => _listener.shutdown(),
              onListen: () => _listener.start(),
              onSay: _onSay,
              onStopSaying: _onStopSaying,
            ),
          ),
          body: Container(
            color: Config.getBackColor(widget.recipe.id),
            child: Stack(
              children: [
                Container(
                  child: _buildCurrentSlide(context, _slideId),
                ),
                Container(
                    alignment: Alignment.bottomCenter, child: _buildSliderBottom())
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setSayingEndHandler(void Function() callback, int slideId) {
    RecipeScreen.tts.setCompletionHandler(() {
      _completed = true;
      if (_listenedBeforeStart!) {
        callback();
      }
    });
    if (!_listenedBeforeStart!) {
      return;
    }
    a() {
      if (slideId == _slideId) {
        callback();
        _completed = true;
      }
      slideId = _slideId;
    }
    RecipeScreen.tts.setCancelHandler(a);
    RecipeScreen.tts.setPauseHandler(a);
  }

  static bool? _listenedBeforeStart;
  static bool _completed = true;

  _onSay() {
    if (_slideId < firstStepSlideId) {
      return;
    }
    if (!ListenButtonState.current()!.isListening()) {
      if (_completed) {
        _listenedBeforeStart = false;
        _setSayingEndHandler(() {}, _slideId);
        _completed = false;
      }
      RecipeScreen.tts.speak(getStep(widget.recipe.id, _slideId -
          firstStepSlideId).description);
      return;
    }
    ListenButtonState.current()!.stopListening();
    _listenedBeforeStart = true;
    _setSayingEndHandler(_restartListening, _slideId);
    _completed = false;
    RecipeScreen.tts.speak(getStep(widget.recipe.id, _slideId -
        firstStepSlideId).description);
  }

  void _restartListening() {
    ListenButtonState.current()!.listen();
  }

  _onStopSaying() {
    RecipeScreen.tts.stop();
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
      color: Colors.black87,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: slidesCount,
        itemBuilder: (_, index) => Container(
          decoration: BoxDecoration(
              color: index == _slideId ? Config.getColor(widget.recipe.id)
                  : Colors.black87,
            borderRadius: BorderRadius.circular(Config.borderRadius)
          ),
          width: sectionWidth,
        ),
      ),
    );
  }

  void _onNext() {
    _changeSlide(_incrementSlideId);
  }

  void _changeSlide(void Function() changer) {
    int prev = _slideId;
    changer();
    if (prev == _slideId) return;
    _onStopSaying();
    setState(() {
      if (SayButtonState.current()!.isSaying()) {
        _onSay();
      }
    });
  }

  void _onPrev() {
    _changeSlide(_decrementSlideId);
  }

  void _initCommandsListener() {
    _listener = CommandsListener(
        commandsList: <Command>[
          NextCommand(onTriggerFunction: _onNext),
          BackCommand(onTriggerFunction: _onPrev),
          SayCommand(onTriggerFunction: () => SayButtonState.current()!.say()),
          StartCommand(onTriggerFunction: () => setState(() {
            _slideId = firstStepSlideId;
          })),
          CloseCommand(onTriggerFunction: () => _onClose(context)),
          StopSayCommand(onTriggerFunction: _onStopSaying),
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
