import 'package:voice_recipe/components/voice_commands/command.dart';

class BackCommand implements Command {
  static const _backWords = ["назад"];
  final void Function() onTriggerFunction;

  BackCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _backWords;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
