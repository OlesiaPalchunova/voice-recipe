import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_sender.dart';
import 'package:voice_recipe/voice_recipe_app.dart';
import 'config.dart';
import 'services/local_notice_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';

Future<void> main() async {
  // Map<String, dynamic> ingr = {
  //   "name" : "Картошка"
  // };
  // Map<String, dynamic> recipeDto = {
  //   "name" : "Борщ",
  //   "ingredients" : [
  //     ingr
  //   ]
  // };
  // var json = jsonEncode(recipeDto);
  // debugPrint(recipeDto.toString());
  await RecipesSender().sendImage("https://i.ibb.co/FwBWwZt/fa63157f1ca9e334322d48aecdee8123.jpg");
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  await Config.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const VoiceRecipeApp());
}
