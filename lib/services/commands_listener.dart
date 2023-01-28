import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_recipe/model/voice_commands/command.dart';

class CommandsListener {
  CommandsListener({required List<Command> commandsList}) {
    _commandsList = commandsList;
  }

  static late List<Command> _commandsList;
  static final _speechToText = SpeechToText();
  static var _speechAvailable = false;
  static var enabled = true;
  static var lastCommandTime = DateTime.now().subtract(const Duration(seconds: 5));
  static const _minSlideChangeDelayMillis = 200;
  static var lastDoneTime = DateTime.wednesday;
  static const String _selectedLocaleId = 'ru_Ru';
  static var listensCount = 0;

  void start() async {
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
    for (Command command in _commandsList) {
      if (command.getTriggerWords().contains(text.toLowerCase())) {
        command.onTrigger()();
        lastCommandTime = current;
      }
    }
  }

  Future _stopListening() async {
    await _speechToText.stop();
  }
}
