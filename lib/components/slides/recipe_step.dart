import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_recipe/components/notifications/slide_notification.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';

class RecipeStepWidget extends StatelessWidget {
  RecipeStepWidget({Key? key, required this.recipe, required this.slideId})
      : super(key: key) {
    int len = stepsResolve[recipe.id].length;
    int idx = min(slideId - 2, len - 1);
    step = stepsResolve[recipe.id][idx];
    flutterTts.setLanguage("ru");
    // controller = VideoPlayerController.asset('assets/videos/tef1.mp4');
    // controller.initialize();
    // controller.setLooping(true);
    // controller.play();
  }

  final Recipe recipe;
  final int slideId;
  final FlutterTts flutterTts = FlutterTts();
  late final RecipeStep step;

  // late final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            HeaderPanel.buildButton(
                context,
                IconButton(
                    onPressed: _pronounce,
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.black87,
                    ))),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              // child: VideoPlayer(controller),
              height: 510,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image(
                  image: AssetImage(step.imgUrl),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                // padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(15)),
                  // height: 120,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    step.description,
                    style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        color: Colors.white),
                  ),
                )),
          ],
        ));
  }

  void _pronounce() {
    flutterTts.speak(step.description);
  }
}
