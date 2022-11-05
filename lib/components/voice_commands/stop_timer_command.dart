import 'package:voice_recipe/components/voice_commands/command.dart';

class StopTimerCommand implements Command {
  static const _words = ["стоп", "таймер стоп"];
  final void Function() onTriggerFunction;

  StopTimerCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _words;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
