import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../screens/recipe_screen.dart';

class CommandsListener {
  CommandsListener({required this.onNext, required this.onPrev});

  late stt.SpeechToText _speech;
  final void Function() onNext;
  final void Function() onPrev;
  static const nextWords = ["дальше", "даша", "вперёд", "польша", "даже"];
  static const backWords = ["назад"];
  var lastCommandTime = DateTime.now();

  void launchRecognition() {
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
          launchRecognition();
        }
      },
    );
  }

  bool _isNextCommand(String command) => nextWords.contains(command.toLowerCase());

  bool _isBackCommand(String command) => backWords.contains(command.toLowerCase());

  void _listen() async {
    _speech.listen(
      localeId: "ru_RU",
      listenFor: const Duration(minutes: 1),
      onResult: (val) {
        var text = val.recognizedWords;
        print(text);
        var current = DateTime.now();
        if (_isNextCommand(text)) {
          if (current.difference(lastCommandTime).inMilliseconds >=
              RecipeScreen.minSlideChangeDelayMillis) {
            lastCommandTime = current;
            onNext();
          }
        } else if (_isBackCommand(text)) {
          if (current.difference(lastCommandTime).inMilliseconds >=
              RecipeScreen.minSlideChangeDelayMillis) {
            lastCommandTime = current;
            onPrev();
          }
        }
        _listen();
      },
    );
  }
}
