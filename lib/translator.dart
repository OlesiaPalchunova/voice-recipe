import 'package:translator/translator.dart';

class Translator {
  final translator = GoogleTranslator();
  static Translator singleton = Translator._internal();

  factory Translator() {
    return singleton;
  }

  Future<String> translateToRu(String input) async {
    final res = await translator.translate(input, from: 'auto', to: 'ru');
    return res.text;
  }

  Translator._internal();
}