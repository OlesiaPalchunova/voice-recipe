import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/util.dart';

class RecipeIngredients extends StatelessWidget {
  const RecipeIngredients({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const _topOffset = 0.06;
  static const _listOffset = 0.05;
  static const _splitterThickness = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Util.borderRadius)),
      margin: const EdgeInsets.all(Util.margin),
      padding: const EdgeInsets.all(Util.padding),
      child: Column(
        children: [
          SizedBox(
            height: Util.pageHeight(context) * _topOffset,
          ),
          GeneralInfo(recipe: recipe),
          const Divider(
            color: Colors.black,
            thickness: _splitterThickness,
          ),
          SizedBox(
            height: Util.pageHeight(context) * _listOffset,
          ),
          IngredientsList(recipe: recipe)
        ],
      ),
    );
  }
}

class IngredientsList extends StatelessWidget {
  IngredientsList({
    Key? key,
    required this.recipe,
  }) : super(key: key) {
    ingredients = ingrResolve[recipe.id];
  }

  final Recipe recipe;
  late final List<Ingredient> ingredients;
  static const _titleSize = 0.032;
  static const _entitySize = 0.024;
  static const _spaceAfterName = 0.01;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ингредиенты",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: Util.pageHeight(context) * _titleSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        SizedBox(
          height: Util.pageHeight(context) * _spaceAfterName,
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: ingredients.length,
          itemBuilder: (_, index) => Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  ingredients[index].name,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: Util.pageHeight(context) * _entitySize,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                Text(
                  ingredients[index].count,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: Util.pageHeight(context) * _entitySize,
                  ),
                ),
              ]),
              const Divider(
                color: Colors.black,
                thickness: RecipeIngredients._splitterThickness,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class GeneralInfo extends StatelessWidget {
  const GeneralInfo({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;
  static const _titleSize = 0.032;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: Util.margin),
          child: Text(
            recipe.name,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: Util.pageHeight(context) * _titleSize,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
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
          margin: const EdgeInsets.symmetric(vertical: Util.margin),
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
  const Assignment(
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
  static const _nameSize = 0.024;
  static const _valueSize = 0.020;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData),
        SizedBox(
          width: Util.pageHeight(context) * _betweenIconAndTextSize,
        ),
        RichText(
          text: TextSpan(
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: Util.pageHeight(context) * _nameSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: "$name\n",
                ),
                TextSpan(
                    text: value,
                    style: TextStyle(
                        fontSize: Util.pageHeight(context) * _valueSize))
              ]),
        ),
      ],
    );
  }
}
