import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CommandsListener {
  CommandsListener(
      {required this.onNext,
      required this.onPrev,
      required this.onSay,
      required this.onStart,
      required this.onExit}) {
    _initSpeechToText();
  }

  late final SpeechToText _speechToText = SpeechToText();
  final void Function() onNext;
  final void Function() onPrev;
  final void Function() onSay;
  final void Function() onStart;
  final void Function() onExit;
  var lastCommandTime = DateTime.now();
  static const _minSlideChangeDelayMillis = 800;
  static const _minDoneDelay = 200;
  static const nextWords = ["дальше", "даша", "вперёд", "польша", "даже"];
  static const backWords = ["назад"];
  static const sayWords = ["скажи"];
  static const startWords = ["начать", "старт", "начало"];
  static const exitWords = ["выйди", "закрой"];
  var lastDoneTime = DateTime.now();

  var _speechAvailable = false;
  final String _selectedLocaleId = 'ru_Ru';

  void start() {
    if (!_speechAvailable) {
      debugPrint("STT module is not available");
    } else {
      _listen();
    }
  }

  void shutdown() {
    _speechToText.cancel();
  }

  void _initSpeechToText() async {
    _speechAvailable = await _speechToText.initialize(
      onStatus: (val) {
        debugPrint('=== onStatus: $val');
        if (val == 'done') {
          // var current = DateTime.now();
          // if (current.difference(lastDoneTime).inMilliseconds.abs() >=
          // _minDoneDelay) {
            start();
            // lastDoneTime = current;
          // }
        }
      },
      onError: (val) {
        debugPrint('=== onError: $val');
        if (val.errorMsg == 'error_speech_timeout' ||
            val.errorMsg == 'error_no_match') {
          start();
        }
      },
    );
  }

  void _listen() async {
    await _stopListening();
    await _speechToText.listen(
      localeId: _selectedLocaleId,
      listenFor: const Duration(hours: 2),
      onResult: (val) {
        var text = val.recognizedWords;
        _handleText(text);
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
