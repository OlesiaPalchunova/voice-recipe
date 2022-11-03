import 'package:voice_recipe/components/voice_commands/command.dart';

class CloseCommand implements Command {
  static const _words = ["закрой", "выйти", "выйди"];
  final void Function() onTriggerFunction;

  CloseCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _words;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
