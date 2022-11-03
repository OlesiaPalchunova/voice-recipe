import 'package:voice_recipe/components/voice_commands/command.dart';

class SayCommand implements Command {
  static const _sayWords = ["скажи", "читай", "говори"];
  final void Function() onTriggerFunction;

  SayCommand({required this.onTriggerFunction});

  @override
  List<String> getTriggerWords() {
    return _sayWords;
  }

  @override
  void Function() onTrigger() {
    return onTriggerFunction;
  }
}
