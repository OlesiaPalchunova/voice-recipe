import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import 'package:voice_recipe/components/recipe_face.dart';
import 'package:voice_recipe/components/recipe_ingredients.dart';
import 'package:voice_recipe/components/recipe_step.dart';

import 'package:voice_recipe/model/recipe_header.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _slideId = 0;
  int _lastDetect = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        final localOffset = box.globalToLocal(details.globalPosition);
        final x = localOffset.dx;
        if(x < box.size.width / 2){
          setState(() {
            _decrementSlideId();
          });
        }else{
          setState(() {
            _incrementSlideId();
          });
        }

      },
      onPanUpdate: (details) {
        int sensitivity = 0;
        int cur = DateTime.now().millisecondsSinceEpoch;
        if (cur - _lastDetect < 500) {
          return;
        }
        if (details.delta.dx != 0) {
          _lastDetect = cur;
        }
        if (details.delta.dx > sensitivity) {
          setState(() {
            _decrementSlideId();
          });
        }
        if (details.delta.dx < sensitivity) {
          setState(() {
            _incrementSlideId();
          });
        }
      },
      child: Scaffold(
        body: Container(
          child: getSlide(_slideId),
        ),
      ),
    );
  }

  void _decrementSlideId() {
    _slideId--;
    _slideId = _slideId < 0 ? 0 : _slideId;
  }

  void _incrementSlideId() {
    _slideId++;
    int max = stepsResolve[widget.recipe.id].length + 1;
    _slideId = _slideId > max ? max : _slideId;
  }

  Widget getSlide(int slideId) {
    if (slideId == 0) {
      return RecipeFace(
        recipe: widget.recipe,
      );
    } else if (slideId == 1) {
      return RecipeIngredients(recipe: widget.recipe);
    }
    return RecipeStepWidget(recipe: widget.recipe, idx: slideId - 1);
  }
}

// class RecipeScreen extends StatefulWidget {
//   const RecipeScreen({
//     Key? key,
//     required this.recipe,
//   }) : super(key: key);
//
//   final Recipe recipe;
//
//   @override
//   _RecipeScreenState createState() => _RecipeScreenState();
// }
//
// class _RecipeScreenState extends State<RecipeScreen> {
//   List<Slide> slides = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return IntroSlider(
//       slides: slides,
//       colorActiveDot: Colors.white,
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     slides.add(
//       Slide(
//         // backgroundImage: widget.recipe.faceImageUrl,
//         centerWidget: RecipeFace(recipe: widget.recipe,),
//       ),
//     );
//     slides.add(
//       Slide(
//           centerWidget: RecipeIngredients(recipe: widget.recipe,)
//       ),
//     );
//   }
// }
