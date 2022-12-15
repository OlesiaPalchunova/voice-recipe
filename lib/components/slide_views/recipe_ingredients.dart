import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';

class IngredientsSlideView extends StatelessWidget {
  const IngredientsSlideView({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const _topOffset = 0.03;
  static const _listOffset = 0.03;
  static const _splitterThickness = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Config.margin).add(
          const EdgeInsets.only(bottom: Config.margin)
      ),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Config.darkModeOn ? Config.iconBackColor: Colors.white70,
          borderRadius: Config.borderRadius
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Config.padding),
          child: Column(
            children: [
              SizedBox(
                height: Config.pageHeight(context) * _topOffset,
              ),
              GeneralInfo(recipe: recipe),
              Divider(
                color: Config.darkModeOn ? Colors.white : Colors.black87,
                thickness: _splitterThickness,
              ),
              SizedBox(
                height: Config.pageHeight(context) * _listOffset,
              ),
              IngredientsList(recipe: recipe)
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientsList extends StatelessWidget {
  IngredientsList({
    Key? key,
    required this.recipe,
  }) : super(key: key) {
    ingredients = recipe.ingredients;
  }

  final Recipe recipe;
  late final List<Ingredient> ingredients;
  final Color _textColor = Config.darkModeOn ? Colors.white : Colors.black87;

  double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 22 : 20;
  double entityFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ингредиенты",
            style: TextStyle(
                fontFamily: Config.fontFamily,
                fontSize: titleFontSize(context),
                fontWeight: FontWeight.bold,
                color: _textColor),
          ),
        ),
        const SizedBox(
          height: Config.margin,
        ),
        Column(
          children: ingredients.map((i) =>
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      i.name,
                      style: TextStyle(
                          fontFamily: Config.fontFamily,
                          fontSize: entityFontSize(context),
                          textBaseline: TextBaseline.alphabetic,
                          color: _textColor
                      ),
                    ),
                    Text(
                      "${i.count} ${i.measureUnit}",
                      style: TextStyle(
                          fontFamily: Config.fontFamily,
                          fontSize: entityFontSize(context),
                          color: _textColor
                      ),
                    ),
                  ]),
            Divider(
            color: _textColor.withOpacity(0.8),
            thickness: IngredientsSlideView._splitterThickness,
            )
                ],
              ),).toList(),
          ),
      ],
    );
  }
}

class GeneralInfo extends StatelessWidget {

  GeneralInfo({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  final Color _textColor = Config.darkModeOn ? Colors.white : Colors.black87;

  double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 22 : 20;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: Config.margin),
          child: Text(
            recipe.name,
            style: TextStyle(
                fontFamily: Config.fontFamily,
                fontSize: titleFontSize(context),
                fontWeight: FontWeight.w400,
                color: _textColor),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assignment(
              recipe: recipe,
              name: "Подготовка",
              value: "${recipe.prepTimeMins} минут",
              iconData: Icons.access_time,
            ),
            Assignment(
              recipe: recipe,
              name: "Приготовление",
              value: "${recipe.cookTimeMins} минут",
              iconData: Icons.access_time,
            )
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: Config.margin),
          child: Assignment(
            recipe: recipe,
            name: "ккал/100г",
            value: "${recipe.kilocalories}",
            iconData: Icons.accessibility_new_outlined,
          ),
        )
      ],
    );
  }
}

class Assignment extends StatelessWidget {
  Assignment(
      {Key? key,
      required this.recipe,
      required this.name,
      required this.value,
      required this.iconData})
      : super(key: key);

  final Recipe recipe;
  final String name;
  final String value;
  final IconData iconData;

  static const _betweenIconAndTextSize = 0.01;
  final Color _textColor = Config.darkModeOn ? Colors.white : Colors.black87;

  double keyFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 20 : 18;
  double valueFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
            iconData,
          color: _textColor,
        ),
        SizedBox(
          width: Config.pageHeight(context) * _betweenIconAndTextSize,
        ),
        RichText(
          text: TextSpan(
              style: TextStyle(
                  fontFamily: Config.fontFamily,
                  fontSize: keyFontSize(context),
                  fontWeight: FontWeight.w400,
                  color: _textColor),
              children: <TextSpan>[
                TextSpan(
                  text: "$name\n",
                ),
                TextSpan(
                    text: value,
                    style: TextStyle(
                        fontSize: valueFontSize(context)))
              ]),
        ),
      ],
    );
  }
}
