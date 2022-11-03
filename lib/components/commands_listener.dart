import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CommandsListener {
  CommandsListener(
      {required void Function() onNext,
      required void Function() onPrev,
      required void Function() onSay,
      required void Function() onStart,
      required void Function() onExit}) {
    staticOnNext = onNext;
    staticOnPrev = onPrev;
    staticOnExit = onExit;
    staticOnSay = onSay;
    staticOnStart = onStart;
  }

  static late void Function() staticOnNext;
  static late void Function() staticOnPrev;
  static late void Function() staticOnSay;
  static late void Function() staticOnStart;
  static late void Function() staticOnExit;
  static final _speechToText = SpeechToText();
  static var _speechAvailable = false;
  static var enabled = true;
  static var lastCommandTime = DateTime.now();
  static const _minSlideChangeDelayMillis = 800;
  static const nextWords = ["дальше", "даша", "вперёд", "польша", "даже"];
  static const backWords = ["назад"];
  static const sayWords = ["скажи", "читай", "говори"];
  static const startWords = ["начать", "старт", "начало"];
  static const exitWords = ["выйди", "закрой"];
  static var lastDoneTime = DateTime.now();

  static const String _selectedLocaleId = 'ru_Ru';
  static var listensCount = 0;

  void start() async {
    debugPrint('START LISTENER');
    enabled = true;
    if (!_speechAvailable) {
      _speechToText.initialize(
        onStatus: (val) {
          debugPrint('=== onStatus: $val');
        },
        onError: (val) {
          debugPrint('=== onError: $val');
          if (enabled && (val.errorMsg == 'error_speech_timeout' ||
          val.errorMsg == 'error_no_match')) {
            _listen();
          }
        },
      ).then((available) {
        if (available) {
          _speechAvailable = true;
          _listen();
        } else {
          debugPrint("Stt is not available");
        }
      });
    } else {
      _listen();
    }
  }

  void shutdown() async {
    enabled = false;
    while (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  void _listen() async {
    listensCount++;
    await _stopListening();
    await _speechToText.listen(
      localeId: _selectedLocaleId,
      listenFor: const Duration(hours: 2),
      onResult: (val) {
        var text = val.recognizedWords;
        _handleText(text);
        if (enabled) {
          _listen();
        }
      },
    );
  }

  void _handleText(String text) {
    debugPrint(text);
    var current = DateTime.now();
    var passed = current.difference(lastCommandTime).inMilliseconds.abs();
    if (passed < _minSlideChangeDelayMillis) {
      debugPrint(
          'Passed not enough time, just $passed / $_minSlideChangeDelayMillis');
      return;
    }
    if (_isNextCommand(text)) {
      lastCommandTime = current;
      staticOnNext();
    } else if (_isBackCommand(text)) {
      lastCommandTime = current;
      staticOnPrev();
    } else if (_isSayCommand(text)) {
      lastCommandTime = current;
      staticOnSay();
    } else if (startWords.contains(text.toLowerCase())) {
      lastCommandTime = current;
      staticOnStart();
    } else if (exitWords.contains(text.toLowerCase())) {
      lastCommandTime = current;
      staticOnExit();
    }
  }

  Future _stopListening() async {
    await _speechToText.stop();
  }

  bool _isNextCommand(String command) =>
      nextWords.contains(command.toLowerCase());

  bool _isBackCommand(String command) =>
      backWords.contains(command.toLowerCase());

  bool _isSayCommand(String command) =>
      sayWords.contains(command.toLowerCase());
}
