import 'package:flutter/material.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'local_notice_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  // LocalNoticeService().addNotification(
  //   title: 'Notification Title',
  //   body: 'Notification Body',
  //   endTime: DateTime.now().add(const Duration(seconds: 1)),
  //   channel: 'testing',
  // );
  runApp(const VoiceRecipeApp());
}
