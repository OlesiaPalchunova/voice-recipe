import 'package:flutter/material.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'config.dart';
import 'services/local_notice_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  if (Config.isWeb) {
    usePathUrlStrategy();
  }
  await Config.init();
  runApp(const VoiceRecipeApp());
}
