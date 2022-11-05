import 'package:voice_recipe/model/voice_commands/command.dart';

class StopSayCommand implements Command {
  static const _words = ["не читай", "не говори"];
  final void Function() onTriggerFunction;

  StopSayCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _words;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
