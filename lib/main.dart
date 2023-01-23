import 'package:flutter/material.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'config.dart';
import 'services/local_notice_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNoticeService().setup();
  var start = DateTime.now();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  var end = DateTime.now();
  debugPrint(end.difference(start).inMilliseconds.toString());
  if (Config.isWeb) {
    usePathUrlStrategy();
  }
  start = DateTime.now();
  await Config.init();
  end = DateTime.now();
  debugPrint(end.difference(start).inMilliseconds.toString());
  runApp(const VoiceRecipeApp());
}
