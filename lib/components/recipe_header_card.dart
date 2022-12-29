import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/favorites_button.dart';
import 'package:voice_recipe/components/review_views/rate_label.dart';

import '../model/recipes_info.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';
import 'package:voice_recipe/config.dart';

class RecipeHeaderCard extends StatefulWidget {
  const RecipeHeaderCard({
    Key? key,
    required this.recipe,
    this.sizeDivider = 1,
    this.showLike = true
  }) : super(key: key);

  final Recipe recipe;
  final double sizeDivider;
  final bool showLike;

  @override
  State<RecipeHeaderCard> createState() => _RecipeHeaderCardState();
}

class _RecipeHeaderCardState extends State<RecipeHeaderCard> {
  var _isPressed = false;
  var _isHovered = false;
  static const gradColor = Colors.black87;
  static const endGradColor = Color.fromRGBO(50, 50, 50, .0);
  static final startGradColor = gradColor.withOpacity(0.8);
  static const maxDesktopHeight = 270.0;
  static bool isDesktop = false;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDesktop = Config.pageWidth(context) >= Config.pageHeight(context);
    height = isDesktop ? maxDesktopHeight : Config.pageHeight(context) * 0.3;
    var supposedWidth = Config.pageWidth(context) * 0.9;
    if (isDesktop) {
      if (supposedWidth < 2 * height * 1.2) {
        width = supposedWidth;
      } else {
        width = height * 1.2;
      }
    } else {
      width = supposedWidth;
    }
  }

  bool get active => _isHovered || _isPressed;

  double get labelWidth => 60;

  Widget get rateLabel => RateLabel(
    rate: rates[widget.recipe.id],
    width: labelWidth,
  );

  Widget get favButton => FavoritesButton(
    recipeId: widget.recipe.id,
  );

  void _onTap() async {
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
  }

  double get spreadRadius => Config.darkModeOn ? 1 : 1;
  double get blurRadius => 6;

  @override
  Widget build(BuildContext context) {
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
        onTap: _onTap,
        child: Card(
            color: const Color.fromRGBO(255, 255, 255, 0),
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
                    color: Colors.grey.shade900,
                    borderRadius: Config.borderRadiusLarge,
                    boxShadow: active
                        ? [
                      BoxShadow(
                        color: Config.getGradientColor(widget.recipe.id).first.darken(12),
                        spreadRadius: spreadRadius,
                        blurRadius: blurRadius,
                        offset: const Offset(2, 2)
                      ),
                      BoxShadow(
                        color: Config.getGradientColor(widget.recipe.id).last.darken(12),
                        spreadRadius: spreadRadius,
                        blurRadius: blurRadius,
                        offset: const Offset(-2, -2)
                      )
                    ]
                        : []),
                height: cardHeight,
                width: cardWidth,
                child: ClipRRect(
                    borderRadius: Config.borderRadiusLarge,
                    child: Image(
                        image: widget.recipe.isNetwork ?
                        NetworkImage(widget.recipe.faceImageUrl)
                            : AssetImage(widget.recipe.faceImageUrl) as ImageProvider,
                        fit: cardWidth <= cardHeight * 1.2
                            ? BoxFit.fitHeight
                            : BoxFit.fitWidth)),
              ),
              Container(
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
                        top: Radius.circular(Config.largeRadius))),
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
                  child: rateLabel
              ),
              Container(
                  width: cardWidth,
                  height: cardHeight,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(Config.padding),
                  child: widget.showLike ? favButton : Container()
              )
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