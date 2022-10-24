import 'package:flutter/material.dart';

import 'package:voice_recipe/components/recipe_face.dart';
import 'package:voice_recipe/components/recipe_ingredients.dart';
import 'package:voice_recipe/components/recipe_step.dart';
import 'package:voice_recipe/components/notifications/slide_notification.dart';

import 'package:voice_recipe/model/recipe_header.dart';

import '../components/header_panel.dart';

class RecipeScreenInherited extends InheritedWidget {
  const RecipeScreenInherited({super.key, required super.child});

  @override
  bool updateShouldNotify(RecipeScreenInherited oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }
}

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
    return NotificationListener<SlideNotification>(
      onNotification: (SlideNotification slideNotification) {
        if (slideNotification.slideId == _slideId) {
          return false;
        }
        setState(() {
          _slideId = slideNotification.slideId;
        });
        return true;
      },
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          _tapHandler(details);
        },
        onPanUpdate: (details) {
          _swipeHandler(details);
        },
        child: Scaffold(
          body: Container(
            color: const Color(
                0xFFE9F7CA
            ),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: _getSlide(_slideId),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 55, horizontal: 10),
                    child: const HeaderPanel()),
              ],
            ),
          ),
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

  Widget _getSlide(int slideId) {
    if (slideId == 0) {
      return RecipeFace(
        recipe: widget.recipe,
      );
    } else if (slideId == 1) {
      return RecipeIngredients(recipe: widget.recipe);
    }
    return RecipeStepWidget(recipe: widget.recipe, idx: slideId - 1);
  }

  void _tapHandler(TapDownDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    final x = localOffset.dx;
    if (x < box.size.width / 2) {
      setState(() {
        _decrementSlideId();
      });
    } else {
      setState(() {
        _incrementSlideId();
      });
    }
  }

  void _swipeHandler(DragUpdateDetails details) {
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
  }
}
