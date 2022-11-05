import 'package:voice_recipe/model/voice_commands/command.dart';

class NextCommand implements Command {
  static const _nextWords = ["дальше", "даша", "вперёд", "польша", "даже"];
  final void Function() onTriggerFunction;

  NextCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _nextWords;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
