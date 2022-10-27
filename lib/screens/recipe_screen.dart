import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:voice_recipe/components/slides/recipe_face.dart';
import 'package:voice_recipe/components/slides/recipe_ingredients.dart';
import 'package:voice_recipe/components/slides/recipe_step.dart';
import 'package:voice_recipe/components/notifications/slide_notification.dart';
import 'package:voice_recipe/components/notifications/tts_notification.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _slideId = 0;
  int _lastDetect = DateTime.now().millisecondsSinceEpoch;
  late stt.SpeechToText _speech;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _launchRecognition();
  }

  void _launchRecognition() {
    _initSpeechToText().then((available) {
      if (available) {
        _listen();
      }
    });
  }

  Future<bool> _initSpeechToText() async {
    _speech = stt.SpeechToText();
    return await _speech.initialize(
      onStatus: (val) => {
        print('onStatus: $val')
      },
      onError: (val) {
        print('onError: $val');
        if (val.errorMsg == 'error_speech_timeout' ||
            val.errorMsg == 'error_no_match') {
          _launchRecognition();
        }
      },
    );
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
    int cur = DateTime.now().millisecondsSinceEpoch;
    if (cur - _lastDetect < 500) {
      return;
    }
    if (details.delta.dx != 0) {
      _lastDetect = cur;
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

  static const nextWords = ["дальше", "даша", "вперёд", "польша", "даже"];
  static const backWords = ["назад"];

  bool _isNextCommand(String command) => nextWords.contains(command.toLowerCase());

  bool _isBackCommand(String command) => backWords.contains(command.toLowerCase());

  void _listen() async {
    _speech.listen(
      localeId: "ru_RU",
      listenFor: const Duration(minutes: 1),
      onResult: (val) => setState(() {
        _text = val.recognizedWords;
        print(_text);
        if (_isNextCommand(_text)) {
          setState(() {
            _incrementSlideId();
          });
        } else if (_isBackCommand(_text)) {
          setState(() {
            _decrementSlideId();
          });
        }
        if (val.hasConfidenceRating && val.confidence > 0) {
          _confidence = val.confidence;
        }
        _listen();
      }),
    );
  }
}
