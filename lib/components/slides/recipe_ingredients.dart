import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/components/header_panel.dart';

class RecipeIngredients extends StatelessWidget {
  const RecipeIngredients({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 50,),
          GeneralInfo(recipe: recipe),
          const Divider(color: Colors.black, thickness: 0.5,),
          const SizedBox(
            height: 40,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Ингредиенты",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        const SizedBox(
          height: 10,
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
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                Text(
                  ingredients[index].count,
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                  ),
                ),
              ]),
              const Divider(color: Colors.black, thickness: 0.5,),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            recipe.name,
            style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 24,
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
          margin: const EdgeInsets.symmetric(vertical: 10),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData),
        const SizedBox(
          width: 5,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: "$name\n",
                ),
                TextSpan(text: value, style: const TextStyle(fontSize: 14))
              ]),
        ),
      ],
    );
  }
}
