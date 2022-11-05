import 'package:voice_recipe/model/voice_commands/command.dart';

class ResetTimerCommand implements Command {
  static const _words = ["сброс", "рестарт", "таймер рестарт"];
  final void Function() onTriggerFunction;

  ResetTimerCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _words;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
