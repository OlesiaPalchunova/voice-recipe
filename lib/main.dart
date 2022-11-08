import 'package:flutter/material.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'local_notice_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  runApp(const VoiceRecipeApp());
}
