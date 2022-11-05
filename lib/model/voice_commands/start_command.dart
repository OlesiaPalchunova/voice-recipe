import 'package:voice_recipe/model/voice_commands/command.dart';

class StartCommand implements Command {
  static const _words = ["начало"];
  final void Function() onTriggerFunction;

  StartCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _words;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
