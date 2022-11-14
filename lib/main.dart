import 'package:flutter/material.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'config.dart';
import 'local_notice_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  await Config.init();
  runApp(const VoiceRecipeApp());
}
