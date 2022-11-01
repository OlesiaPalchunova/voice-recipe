import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CommandsListener {
  CommandsListener(
      {required this.onNext,
      required this.onPrev,
      required this.onSay,
      required this.onStart,
      required this.onExit});

  late final SpeechToText _speechToText = SpeechToText();
  final void Function() onNext;
  final void Function() onPrev;
  final void Function() onSay;
  final void Function() onStart;
  final void Function() onExit;
  var lastCommandTime = DateTime.now();
  static const _minSlideChangeDelayMillis = 800;
  static const nextWords = ["дальше", "даша", "вперёд", "польша", "даже",
    "некст", "нэкст", "ещё", "го"];
  static const backWords = ["назад"];
  static const sayWords = ["скажи", "читай", "говори"];
  static const startWords = ["начать", "старт", "начало"];
  static const exitWords = ["выйди", "закрой"];
  var lastDoneTime = DateTime.now();
  var enabled = true;

  var _speechAvailable = false;
  final String _selectedLocaleId = 'ru_Ru';
  var listensCount = 0;

  void start() async {
    enabled = true;
    if (!_speechAvailable) {
      _speechToText.initialize(
        onStatus: (val) {
          debugPrint('=== onStatus: $val');
          if (val == 'done' && enabled) {
          }
        },
        onError: (val) {
          debugPrint('=== onError: $val');
          if (enabled && val.errorMsg == 'error_speech_timeout' ||
              val.errorMsg == 'error_no_match') {
            // debugPrint('launch _listen() again');
            debugPrint('call _listen after ${val.errorMsg}');
            _listen();
          }
        },
      ).then((available) {
        if (available) {
          _speechAvailable = true;
          debugPrint('call _listen in start() 1');
          _listen();
        } else {
          debugPrint("Stt is not available");
        }
      });
    } else {
      debugPrint('call _listen in start() 2');
      _listen();
    }
  }

  void shutdown() {
    enabled = false;
    _speechToText.cancel();
    _speechToText.stop();
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
          debugPrint("total count of calls to _listen(): $listensCount");
          debugPrint('call _listen() from itself');
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
      debugPrint('detected next command');
      onNext();
      debugPrint('called onNext()');
    } else if (_isBackCommand(text)) {
      lastCommandTime = current;
      onPrev();
    } else if (_isSayCommand(text)) {
      lastCommandTime = current;
      onSay();
    } else if (startWords.contains(text.toLowerCase())) {
      lastCommandTime = current;
      onStart();
    } else if (exitWords.contains(text.toLowerCase())) {
      lastCommandTime = current;
      onExit();
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
