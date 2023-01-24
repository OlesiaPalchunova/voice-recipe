import 'package:flutter/material.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'config.dart';
import 'services/local_notice_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:routemaster/routemaster.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNoticeService().setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  if (Config.isWeb) {
    Routemaster.setPathUrlStrategy();
  }
  await Config.init();
  runApp(const VoiceRecipeApp());
}
