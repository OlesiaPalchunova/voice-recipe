import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart';
import 'package:voice_recipe/components/buttons/arrow.dart';
import 'package:voice_recipe/components/buttons/listen_button.dart';
import 'package:voice_recipe/components/buttons/say_button.dart';
import 'package:voice_recipe/components/slide_views/reviews_slide.dart';
import 'package:voice_recipe/components/slider_gesture_handler.dart';

import 'package:voice_recipe/model/commands_listener.dart';
import 'package:voice_recipe/components/slide_views/recipe_face.dart';
import 'package:voice_recipe/components/slide_views/recipe_ingredients.dart';
import 'package:voice_recipe/components/slide_views/recipe_step_view.dart';
import 'package:voice_recipe/components/timer/timer_view.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
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
    reviewPage.updateComments();
  }

  final Recipe recipe;
  static final FlutterTts tts = FlutterTts();
  late final IngredientsSlideView ingPage =
      IngredientsSlideView(recipe: recipe);
  late final RecipeFaceSlideView facePage = RecipeFaceSlideView(recipe: recipe);
  late final ReviewsSlide reviewPage = ReviewsSlide(recipe: recipe);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  static const faceSlideId = 0;
  static const ingredientsSlideId = 1;
  static const firstStepSlideId = 2;
  static int _slideId = 0;
  late CommandsListener _listener;
  static final stepsMap = HashMap<int, int>();

  @override
  void initState() {
    super.initState();
    _slideId = stepsMap[widget.recipe.id] ?? 0;
    _initCommandsListener();
  }

  @override
  void dispose() {
    super.dispose();
    stepsMap[widget.recipe.id] = _slideId;
    RecipeScreen.tts.stop();
    _listener.shutdown();
  }

  List<Widget> getBodyWidgets() {
    List<Widget> list = [];
    bool showButtons = Config.isWeb && Config.pageWidth(context) > 800;
    double arrowSize = Config.pageWidth(context) / 8;
    if (showButtons) {
      list.add(
        SizedBox(
          height: arrowSize,
          width: arrowSize,
          child: _slideId != 0
              ? ArrowButton(
                  direction: Direction.left,
                  onTap: _onPrev,
                )
              : null,
        ),
      );
    }
    list.add(Stack(children: [
      Center(
        child: Container(
          color: Config.getBackColor(widget.recipe.id),
          alignment: Alignment.center,
          width: Config.recipeSlideWidth(context),
          child: _buildCurrentSlide(context, _slideId),
        ),
      ),
      Center(
        child: Container(
            alignment: Alignment.bottomCenter,
            width: Config.recipeSlideWidth(context),
            child: _buildSliderBottom()),
      )
    ]));
    if (showButtons) {
      list.add(SizedBox(
          height: arrowSize,
          width: arrowSize,
          child: _slideId != widget.recipe.steps.length + 1 + 1
              ? ArrowButton(
                  direction: Direction.right,
                  onTap: _onNext,
                )
              : null));
    }
    return list;
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
            shadowColor: Config.darkModeOn
                ? Colors.black87
                : Colors.white.withOpacity(0),
            automaticallyImplyLeading: false,
            toolbarHeight: 60,
            foregroundColor: Config.iconColor,
            backgroundColor: Config.getBackColor(widget.recipe.id),
            centerTitle: true,
            title: Container(
              alignment: Alignment.center,
              width: Config.maxRecipeSlideWidth,
              child: HeaderButtonsPanel(
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
          ),
          body: Container(
              alignment: Alignment.center,
              color: Config.darkModeOn
                  ? Config.backgroundColor
                  : Config.getBackColor(widget.recipe.id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getBodyWidgets(),
              )),
        ),
      ),
    );
  }

  void _completeSaying() {
    _completed = true;
    ListenButtonState.current()!.unlock();
  }

  void _setSayingEndHandler(void Function() callback, int slideId) {
    RecipeScreen.tts.setCompletionHandler(() {
      _completeSaying();
      if (_listenedBeforeStart!) {
        callback();
      }
    });
    a() {
      if (slideId == _slideId) {
        callback();
        _completeSaying();
      }
      slideId = _slideId;
    }

    RecipeScreen.tts.setCancelHandler(a);
    RecipeScreen.tts.setPauseHandler(a);
  }

  static bool? _listenedBeforeStart;
  static bool _completed = true;

  _onSay() {
    String text = "";
    if (_slideId == faceSlideId) {
      text = widget.recipe.name;
    } else if (_slideId == ingredientsSlideId) {
      text = "Время приготовления: ${widget.recipe.cookTimeMins} минут";
    } else {
      text = widget.recipe.steps[_slideId - firstStepSlideId].description;
    }
    if (!ListenButtonState.current()!.isListening()) {
      if (_completed) {
        _listenedBeforeStart = false;
        _setSayingEndHandler(() {}, _slideId);
        _completed = false;
        ListenButtonState.current()!.lock();
      }
      RecipeScreen.tts.speak(text);
      return;
    }
    ListenButtonState.current()!.stopListening();
    _listenedBeforeStart = true;
    _setSayingEndHandler(_restartListening, _slideId);
    _completed = false;
    ListenButtonState.current()!.lock();
    RecipeScreen.tts.speak(text);
  }

  void _restartListening() {
    ListenButtonState.current()!.listen();
  }

  _onStopSaying() {
    RecipeScreen.tts.stop();
  }

  Widget _buildCurrentSlide(BuildContext context, int slideId) {
    if (slideId == faceSlideId) {
      return widget.facePage;
    } else if (slideId == ingredientsSlideId) {
      return widget.ingPage;
    } else if (slideId == widget.recipe.steps.length + 1 + 1) {
      return widget.reviewPage;
    }
    return RecipeStepView(
      recipe: widget.recipe,
      slideId: slideId,
    );
  }

  Widget _buildSliderBottom() {
    var width = min(Config.pageWidth(context), Config.maxRecipeSlideWidth);
    var slidesCount = 1 + 1 + 1 + widget.recipe.steps.length;
    var sectionWidth = width / slidesCount;
    return Container(
      alignment: Alignment.center,
      height: 10,
      decoration: BoxDecoration(
          color:
              Config.darkModeOn ? Config.backgroundColor : Colors.grey.shade800,
          borderRadius: Config.borderRadius),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: slidesCount,
        itemBuilder: (_, index) => Container(
          decoration: BoxDecoration(
              color:
                  index == _slideId ? Config.getColor(widget.recipe.id) : null,
              borderRadius: Config.borderRadius),
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
    _listener = CommandsListener(commandsList: <Command>[
      NextCommand(onTriggerFunction: _onNext),
      BackCommand(onTriggerFunction: _onPrev),
      SayCommand(onTriggerFunction: () => SayButtonState.current()!.say()),
      StartCommand(
          onTriggerFunction: () => setState(() {
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
    ]);
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
    int max = widget.recipe.steps.length + 1 + 1;
    _slideId = _slideId > max ? max : _slideId;
  }
}
