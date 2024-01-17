import 'package:flutter/material.dart';
import 'package:voice_recipe/components/labels/time_label.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config/config.dart';

class IngredientsSlideView extends StatelessWidget {
  const IngredientsSlideView({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const splitterThickness = .3;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Config.margin).add(
          const EdgeInsets.only(bottom: Config.margin)
      ),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Config.darkModeOn ? Config.iconBackColor: Colors.white70,
          borderRadius: Config.borderRadiusLarge
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Config.padding),
          child: Column(
            children: [
              const SizedBox(
                height: Config.margin,
              ),
              GeneralInfo(recipe: recipe),
              Divider(
                color: Config.darkModeOn ? Colors.white : Colors.black87,
                thickness: splitterThickness,
              ),
              const SizedBox(
                height: Config.margin * 3,
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

  static final zeroRegex = RegExp(r'([.]*0)(?!.*\d)');

  static String ingCountStr(Ingredient i) {
    String first = "${i.count.toString().replaceAll(zeroRegex, '')} ${i.measureUnit}";
    return first.replaceAll(',', '.').replaceAll('1 ед.', '').replaceAll('1 .', '1.')
    .replaceAll(' ед.', '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Ингредиенты",
            style: TextStyle(
                fontFamily: Config.fontFamily,
                fontSize: titleFontSize(context),
                fontWeight: FontWeight.bold,
                color: _textColor),
        ),
        const SizedBox(
          height: Config.margin,
        ),
        Column(
          children: ingredients.map((ing) => ingredientView(context, ing)).toList(),
          ),
      ],
    );
  }

  Widget ingredientView(BuildContext context, Ingredient ing) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            flex: 3,
            child: SelectableText(
              ing.name,
              style: TextStyle(
                  fontFamily: Config.fontFamily,
                  fontSize: entityFontSize(context),
                  textBaseline: TextBaseline.alphabetic,
                  color: _textColor
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                ingCountStr(ing),
                style: TextStyle(
                    fontFamily: Config.fontFamily,
                    fontSize: entityFontSize(context),
                    color: _textColor
                ),
              ),
            ),
          ),
        ]),
        Divider(
          color: _textColor.withOpacity(0.8),
          thickness: IngredientsSlideView.splitterThickness,
        )
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
    print(recipe.portions);
    print("recipe.portions");
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
              name: "Подготовка\n",
              value: TimeLabel.timeToStr(TimeLabel.convertToTOD(recipe.prepTimeMins)),
              iconData: Icons.access_time,
            ),
            Assignment(
              name: "Приготовление\n",
              value: TimeLabel.timeToStr(TimeLabel.convertToTOD(recipe.cookTimeMins)),
              iconData: Icons.access_time,
            )
          ],
        ),
        recipe.portions != null ?
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Config.margin),
          child: Assignment(
            name: "Количество порций:  ",
            value: recipe.portions.toString(),
            iconData: Icons.coffee_outlined,
          ),
        )
        : SizedBox(),
        // recipes at the current moment don't have calories, so I commented this
        // Container(
        //   alignment: Alignment.centerLeft,
        //   margin: const EdgeInsets.symmetric(vertical: Config.margin),
        //   child: Assignment(
        //     recipe: recipe,
        //     name: "ккал/100г",
        //     value: "${recipe.kilocalories}",
        //     iconData: Icons.accessibility_new_outlined,
        //   ),
        // )
      ],
    );
  }
}

class Assignment extends StatelessWidget {
  Assignment(
      {Key? key,
      required this.name,
      required this.value,
      required this.iconData})
      : super(key: key);

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
                  text: "$name",
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
