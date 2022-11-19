import 'package:flutter/material.dart';
import 'package:voice_recipe/components/review/rate_label.dart';

import '../model/recipes_info.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';
import 'package:voice_recipe/config.dart';

class RecipeHeaderCard extends StatefulWidget {
  const RecipeHeaderCard({
    Key? key,
    required this.recipe,
    this.sizeDivider = 1,
  }) : super(key: key);

  final Recipe recipe;
  final double sizeDivider;

  @override
  State<RecipeHeaderCard> createState() => _RecipeHeaderCardState();
}

class _RecipeHeaderCardState extends State<RecipeHeaderCard> {
  var _isPressed = false;
  var _isHovered = false;
  static const gradColor = Colors.black87;
  static final endGradColor = gradColor.withOpacity(0);
  static final startGradColor = gradColor.withOpacity(0.8);
  static const maxDesktopHeight = 270.0;
  static bool isDesktop = false;

  double get height {
    return isDesktop ? maxDesktopHeight : Config.pageHeight(context) * 0.3;
  }

  double get width {
    double height = this.height;
    var supposedWidth = Config.pageWidth(context) * 0.9;
    if (isDesktop) {
      if (supposedWidth < 2 * height * 1.2) {
        return supposedWidth;
      }
      return height * 1.2;
    }
    return supposedWidth;
  }

  bool get active => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    isDesktop = Config.pageWidth(context) >= Config.pageHeight(context);
    var cardWidth = width;
    var cardHeight = height;
    var smallCards = false;
    if (!isDesktop && widget.sizeDivider != 1) {
      smallCards = true;
      cardWidth = cardWidth / widget.sizeDivider;
      cardHeight = cardWidth;
    }
    return InkWell(
        onHover: (hovered) {
          setState(() {
            _isHovered = hovered;
          });
        },
        onTap: () async {
          setState(() {
            _isPressed = true;
          });
          a() {
            setState(() {
              _isPressed = false;
              _isHovered = false;
            });
            _navigateToRecipe(context, widget.recipe);
          }

          await Future.delayed(Config.animationTime).whenComplete(a);
        },
        child: Card(
            color: Colors.white.withOpacity(0),
            elevation: 0,
            margin:
                EdgeInsets.all(smallCards ? Config.margin / 2 : Config.margin),
            child: Stack(children: [
              AnimatedContainer(
                onEnd: () {
                  setState(() {
                    _isPressed = false;
                  });
                },
                duration: Config.shortAnimationTime,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Config.borderRadiusLarge),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: Config.getColor(widget.recipe.id),
                              blurRadius: 12,
                              // offset: const Offset(4, 4)
                            )
                          ]
                        : []),
                height: cardHeight,
                width: cardWidth,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Config.borderRadiusLarge),
                    child: Image(
                        image: AssetImage(widget.recipe.faceImageUrl),
                        fit: cardWidth <= cardHeight * 1.2
                            ? BoxFit.fitHeight
                            : BoxFit.fitWidth)),
              ),
              AnimatedContainer(
                duration: Config.shortAnimationTime,
                width: cardWidth,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          startGradColor,
                          endGradColor,
                        ]),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(Config.borderRadiusLarge))),
                // width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    cardWidth / 10, cardHeight / 7, 0, cardHeight / 5),
                child: Text(
                  widget.recipe.name,
                  style: TextStyle(
                      fontFamily: Config.fontFamilyBold,
                      fontSize: cardHeight / 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
              ),
              Container(
                  width: cardWidth,
                  height: cardHeight,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(Config.padding),
                  child: RateLabel(
                    justDark: true,
                    rate: rates[widget.recipe.id],
                    width: Config.isDesktop(context) ? 65 : 50,
                  ))
            ])));
  }

  void _navigateToRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)));
  }
}
