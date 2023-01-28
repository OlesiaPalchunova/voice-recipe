import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intro_slider/intro_slider.dart';

import 'package:voice_recipe/components/buttons/arrow.dart';
import 'package:voice_recipe/components/buttons/listen_button.dart';
import 'package:voice_recipe/components/buttons/say_button.dart';
import 'package:voice_recipe/components/review_views/comment_card.dart';
import 'package:voice_recipe/components/slide_views/reviews_slide.dart';
import 'package:voice_recipe/components/utils/slider_gesture_handler.dart';
import 'package:voice_recipe/components/mini_ing_list.dart';

import 'package:voice_recipe/services/commands_listener.dart';
import 'package:voice_recipe/components/slide_views/recipe_face.dart';
import 'package:voice_recipe/components/slide_views/recipe_ingredients.dart';
import 'package:voice_recipe/components/slide_views/recipe_step_view.dart';
import 'package:voice_recipe/components/timer/timer_view.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config/config.dart';

import 'package:voice_recipe/model/voice_commands/close_command.dart';
import 'package:voice_recipe/model/voice_commands/command.dart';
import 'package:voice_recipe/model/voice_commands/next_command.dart';
import 'package:voice_recipe/model/voice_commands/reset_timer_command.dart';
import 'package:voice_recipe/model/voice_commands/say_command.dart';
import 'package:voice_recipe/model/voice_commands/start_command.dart';
import 'package:voice_recipe/model/voice_commands/prev_command.dart';
import 'package:voice_recipe/model/voice_commands/start_timer_command.dart';
import 'package:voice_recipe/model/voice_commands/stop_timer_command.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../model/voice_commands/stop_say.dart';

class RecipePage extends StatefulWidget {
  RecipePage({
    Key? key,
    required this.recipe,
  }) : super(key: key) {
    tts.setLanguage("ru");
    reviewPage.updateComments();
    slides.add(facePage);
    slides.add(ingPage);
    for (int i = 2; i <= recipe.steps.length + 1; i++) {
      slides.add(RecipeStepView(recipe: recipe, slideId: i));
    }
    slides.add(reviewPage);
  }

  final Recipe recipe;
  static final FlutterTts tts = FlutterTts();
  late final IngredientsSlideView ingPage =
      IngredientsSlideView(recipe: recipe);
  late final RecipeFaceSlideView facePage = RecipeFaceSlideView(recipe: recipe);
  late final ReviewsSlide reviewPage = ReviewsSlide(recipe: recipe);
  final List<Widget> slides = [];

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  static const faceSlideId = 0;
  static const ingredientsSlideId = 1;
  static const firstStepSlideId = 2;
  static int _slideId = 0;
  late CommandsListener _listener;
  static final stepsMap = HashMap<int, int>();
  static const Duration slidingTime = Duration(milliseconds: 350);
  bool showMiniIngList = false;
  final hideBackButton = ValueNotifier(false);
  final hideNextButton = ValueNotifier(false);
  late Function goToTab;
  List<ContentConfig> listContentConfig = [];
  late Color activeColor = Config.getColor(widget.recipe.id);
  DateTime tapTime = DateTime.now();

  double sizeIndicator(BuildContext context) =>
      .3 * Config.constructorWidth(context) / (widget.slides.length * 1.5);

  Color get inactiveColor => activeColor;

  @override
  void initState() {
    super.initState();
    _slideId = stepsMap[widget.recipe.id] ?? 0;
    checkToHideButtons();
    _initCommandsListener();
  }

  void checkToHideButtons() {
    if (_slideId == 0) {
      hideBackButton.value = true;
    } else {
      if (hideBackButton.value) hideBackButton.value = false;
    }
    if (_slideId == lastSlideId) {
      hideNextButton.value = true;
    } else {
      if (hideNextButton.value) hideNextButton.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    stepsMap[widget.recipe.id] = _slideId;
    RecipePage.tts.stop();
    _listener.shutdown();
  }

  int get lastSlideId => widget.slides.length - 1;

  Widget buildSlider(BuildContext context) {
    listContentConfig.clear();
    for (Widget slide in widget.slides) {
      listContentConfig.add(ContentConfig(
          marginTitle: const EdgeInsets.all(0.0),
          verticalScrollbarBehavior: ScrollbarBehavior.hide,
          marginDescription: const EdgeInsets.all(0.0),
          widgetTitle: SliderGestureHandler(
            handleKeyboard: Config.isWeb,
            customOnTap: () {
              ReviewsSlide.newCommentNode.unfocus();
              CommentCard.editNode.unfocus();
            },
            onEscape: () => _onClose(context),
            onRight: _onNext,
            onLeft: _onPrev,
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    height: Config.pageHeight(context) * .85,
                    width: Config.maxRecipeSlideWidth,
                    alignment: Alignment.topCenter,
                    child: slide)),
          )));
    }
    final slider = IntroSlider(
      listContentConfig: listContentConfig,
      backgroundColorAllTabs: Config.getBackColor(widget.recipe.id),
      isShowSkipBtn: false,
      isShowPrevBtn: false,
      isShowNextBtn: false,
      isShowDoneBtn: false,
      refFuncGoToTab: (refFunc) {
        goToTab = refFunc;
        if (_slideId > 0) {
          goToTab(_slideId);
        }
      },
      onTabChangeCompleted: (id) {
        _slideId = id;
      },
      indicatorConfig: IndicatorConfig(
        sizeIndicator: sizeIndicator(context),
        indicatorWidget: Container(
          width: sizeIndicator(context),
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: inactiveColor),
        ),
        activeIndicatorWidget: Container(
          width: sizeIndicator(context),
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: activeColor),
        ),
        spaceBetweenIndicator: sizeIndicator(context) * .5,
        typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
      ),
      navigationBarConfig: NavigationBarConfig(
        navPosition: NavPosition.bottom,
        padding: const EdgeInsets.all(0.0),
      ),
      isAutoScroll: false,
      isLoopAutoScroll: false,
      curveScroll: Curves.fastOutSlowIn,
    );
    return slider;
  }

  Color get backgroundColor => Config.getBackColor(widget.recipe.id);

  List<Widget> getBodyWidgets(BuildContext context) {
    List<Widget> list = [];
    list.addAll(
      [
        buildSlider(context),
        Center(
          child: Container(
              width: Config.recipeSlideWidth(context),
              alignment: Alignment.topRight,
              padding: Config.paddingAll,
              child: MiniIngredientsList(recipe: widget.recipe)),
        )
      ],
    );
    bool showButtons = Config.isWeb && Config.pageWidth(context) > 800;
    if (!showButtons) return list;
    double arrowSize = Config.pageWidth(context) / 16;
    double contSize =
        (Config.pageWidth(context) - Config.maxRecipeSlideWidth) / 2;
    list.add(Center(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: contSize,
              height: double.infinity,
              color: backgroundColor,
              alignment: Alignment.centerRight,
              child: SizedBox(
                  height: arrowSize,
                  width: arrowSize,
                  child: ArrowButton(
                    hideNotify: hideBackButton,
                    direction: Direction.left,
                    onTap: _onPrev,
                  )),
            ),
            const SizedBox(width: Config.maxRecipeSlideWidth),
            Container(
              width: contSize,
              height: double.infinity,
              color: backgroundColor,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  height: arrowSize,
                  width: arrowSize,
                  child: ArrowButton(
                    hideNotify: hideNextButton,
                    direction: Direction.right,
                    onTap: _onNext,
                  )),
            ),
          ]),
    ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Config.darkModeOn ? Colors.black87 : Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          foregroundColor: Config.iconColor,
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            width: Config.maxRecipeSlideWidth,
            child: HeaderButtonsPanel(
              id: widget.recipe.id,
              onClose: _onClose,
              onList: () {
                if (MiniIngredientsListState.current == null) return;
                showMiniIngList = !showMiniIngList;
                if (showMiniIngList) {
                  MiniIngredientsListState.current!.moveOut();
                } else {
                  MiniIngredientsListState.current!.moveBack();
                }
              },
              onMute: () {
                if (Config.isWeb) {
                  ServiceIO.showAlertDialog(
                      "К сожалению, голосове управление на данный момент работает только в мобильной версии.",
                      context);
                  return;
                }
                _listener.shutdown();
              },
              onListen: () {
                if (Config.isWeb) {
                  ServiceIO.showAlertDialog(
                      "К сожалению, голосове управление на данный момент работает только в мобильной версии.",
                      context);
                  return;
                }
                _listener.start();
              },
              onSay: _onSay,
              onStopSaying: _onStopSaying,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          color: Config.darkModeOn
              ? Config.backgroundColor
              : Config.getBackColor(widget.recipe.id),
          child: Stack(children: getBodyWidgets(context)),
        ),
      ),
    );
  }

  void _completeSaying() {
    _completed = true;
    HeaderButtonsPanel.isLockedListening.value = false;
  }

  void _setSayingEndHandler(void Function() callback, int slideId) {
    RecipePage.tts.setCompletionHandler(() {
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

    RecipePage.tts.setCancelHandler(a);
    RecipePage.tts.setPauseHandler(a);
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
    if (!HeaderButtonsPanel.isListening.value) {
      if (_completed) {
        _listenedBeforeStart = false;
        _setSayingEndHandler(() {}, _slideId);
        _completed = false;
        HeaderButtonsPanel.isLockedListening.value = true;
      }
      RecipePage.tts.speak(text);
      return;
    }
    HeaderButtonsPanel.isListening.value = false;
    _listenedBeforeStart = true;
    _setSayingEndHandler(_restartListening, _slideId);
    _completed = false;
    HeaderButtonsPanel.isLockedListening.value = true;
    RecipePage.tts.speak(text);
  }

  void _restartListening() {
    HeaderButtonsPanel.isListening.value = true;
  }

  _onStopSaying() {
    RecipePage.tts.stop();
  }

  void _onNext() {
    _changeSlide(_incrementSlideId);
  }

  void _changeSlide(void Function() changer) {
    DateTime current = DateTime.now();
    if (current.difference(tapTime) < slidingTime) {
      return;
    }
    tapTime = current;
    int prev = _slideId;
    changer();
    if (prev == _slideId) return;
    _onStopSaying();
    goToTab(_slideId);
    checkToHideButtons();
    if (HeaderButtonsPanel.isSaying.value) {
      _onSay();
    }
  }

  void _onPrev() {
    _changeSlide(_decrementSlideId);
  }

  void _initCommandsListener() {
    _listener = CommandsListener(commandsList: <Command>[
      NextCommand(onTriggerFunction: _onNext),
      BackCommand(onTriggerFunction: _onPrev),
      SayCommand(
          onTriggerFunction: () => HeaderButtonsPanel.isSaying.value = true),
      StartCommand(onTriggerFunction: () => goToTab(firstStepSlideId)),
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
    ReviewsSlide.commentController.clear();
    _listener.shutdown();
    Navigator.of(context).pop();
  }

  void _decrementSlideId() {
    _slideId--;
    _slideId = _slideId < 0 ? 0 : _slideId;
  }

  void _incrementSlideId() {
    _slideId++;
    _slideId = _slideId > lastSlideId ? lastSlideId : _slideId;
  }
}
