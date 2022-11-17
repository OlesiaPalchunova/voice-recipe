import 'dart:math';

import 'package:flutter/material.dart';

import '../model/recipes_info.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';
import 'package:voice_recipe/config.dart';

class RecipeHeaderCard extends StatefulWidget {
  const RecipeHeaderCard({
    Key? key,
    required this.recipe,
    this.width = maxWidth,
    this.fontResizer = 1
  }) : super(key: key);

  final Recipe recipe;
  static const borderRadius = 16.0;
  static const maxWidth = 380.0;
  static const maxHeight = 290.0;
  static const heightPerWidth = 0.76;
  final double width;
  final double fontResizer;

  @override
  State<RecipeHeaderCard> createState() => _RecipeHeaderCardState();
}

class _RecipeHeaderCardState extends State<RecipeHeaderCard> {
  var _isPressed = false;

  double _getCardWidth(BuildContext context) {
    var screenWidth = Config.pageWidth(context);
    return min(widget.width, min(screenWidth * 0.9, RecipeHeaderCard.maxWidth));
  }

  double _getCardHeight(BuildContext context) {
    return _getCardWidth(context) * RecipeHeaderCard.heightPerWidth;
  }

  @override
  Widget build(BuildContext context) {
    const gradColor = Colors.black87;
    final endGradColor = gradColor.withOpacity(0);
    final startGradColor = gradColor.withOpacity(0.8);
    final cardWidth = _getCardWidth(context);
    final cardHeight = _getCardHeight(context);
    return GestureDetector(
        onTap: () {
          setState(() {
            _isPressed = !_isPressed;
          });
        },
        child: Card(
            color: Colors.white.withOpacity(0),
            elevation: 0,
            margin: const EdgeInsets.all(Config.margin / 2),
            child: Stack(children: [
              AnimatedContainer(
                onEnd: () {
                  if (_isPressed) {
                    _navigateToRecipe(context, widget.recipe);
                  }
                  setState(() {
                    _isPressed = false;
                  });
                },
                duration: Config.shortAnimationTime,
                decoration: BoxDecoration(
                    boxShadow: _isPressed
                        ? [
                      BoxShadow(
                          color: Config.getColor(widget.recipe.id),
                          blurRadius: 12,
                          // offset: const Offset(4, 4)
                      )
                    ] : []
                ),
                height: cardHeight,
                width: cardWidth,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(RecipeHeaderCard.borderRadius
                        ),
                    child: Image(
                      image: widget.recipe.faceImage,
                      fit: BoxFit.fitHeight,
                    )
                ),
              ),
              AnimatedContainer(
                duration: Config.shortAnimationTime,
                width: _getCardWidth(context),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          startGradColor,
                          endGradColor,
                        ]
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(RecipeHeaderCard.borderRadius)
                    )
                ),
                // width: double.infinity,
                padding: EdgeInsets.fromLTRB(cardWidth / 10, cardHeight / 7,
                    0, cardHeight / 5),
                child: Text(
                  widget.recipe.name,
                  style: TextStyle(
                      fontFamily: Config.fontFamilyBold,
                      fontSize: widget.fontResizer * cardHeight / 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.white
                  ),
                ),
              ),
            ]
            )
        )
    );
  }

  void _navigateToRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)));
  }
}
