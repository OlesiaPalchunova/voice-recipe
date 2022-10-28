import 'package:speech_to_text/speech_to_text.dart' as stt;

class CommandsListener {
  CommandsListener({required this.onNext, required this.onPrev, required this.onSay,
  required this.onStart, required this.onExit});

  late stt.SpeechToText _speech;
  final void Function() onNext;
  final void Function() onPrev;
  final void Function() onSay;
  final void Function() onStart;
  final void Function() onExit;
  var lastCommandTime = DateTime.now();
  static const _minSlideChangeDelayMillis = 800;

  static const nextWords = ["дальше", "даша", "вперёд", "польша", "даже"];
  static const backWords = ["назад"];
  static const sayWords = ["скажи"];
  static const startWords = ["начать", "старт", "начало"];
  static const exitWords = ["выйди", "закрой"];

  void launchRecognition() {
    _initSpeechToText().then((available) {
      if (available) {
        _listen();
      }
    });
  }

  void shutdown() {
    _speech.cancel();
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

  bool _isSayCommand(String command) => sayWords.contains(command.toLowerCase());

  void _listen() async {
    _speech.listen(
      localeId: "ru_RU",
      listenFor: const Duration(hours: 2),
      onResult: (val) {
        var text = val.recognizedWords;
        print(text);
        var current = DateTime.now();
        var passed = current.difference(lastCommandTime).inMilliseconds.abs();
        if (passed >=
            _minSlideChangeDelayMillis) {
          if (_isNextCommand(text)) {
            print('NEXT');
            lastCommandTime = current;
            onNext();
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
        } else {
          print('PASSED $passed');
        }
        _listen();
      },
    );
  }
}
