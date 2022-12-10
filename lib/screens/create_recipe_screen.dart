import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/create_recipe/header_label.dart';
import 'package:voice_recipe/components/create_recipe/ingredients_label.dart';
import 'package:voice_recipe/components/create_recipe/steps_label.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';

import '../config.dart';
import '../model/recipes_info.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();

  static double generalFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

  static double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 19 : 17;

  static Color get buttonColor => Config.darkModeOn
  ? const Color(0xff474645)
  : const Color(0xeecccccc);

  static Widget title(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.only(left: Config.padding),
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: TextStyle(
              fontFamily: Config.fontFamily,
              color: Config.iconColor,
              fontSize: titleFontSize(context))),
    );
  }

  static double pageWidth(BuildContext context) =>
      Config.recipeSlideWidth(context);
}

enum HeaderField { name, faceImageUrl, cookTimeMins, prepTimeMins }

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  static final List<Ingredient> ingredients = [];
  static final List<RecipeStep> steps = [];
  static final Map<HeaderField, dynamic> headers = {};

  Color get backgroundColor =>
      Config.darkModeOn ? Config.backgroundColor : ClassicButton.color;

  Color get labelColor =>
      !Config.darkModeOn ? Config.backgroundColor : ClassicButton.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(
        title: "Создать новый рецепт",
      ).appBar(),
      backgroundColor: backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/decorations/create_back.jpg"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: Config.margin * 2),
              alignment: Alignment.topCenter,
              width: CreateRecipeScreen.pageWidth(context),
              child: Column(
                children: allLabels(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Recipe? createdRecipe;

  void submitRecipe() {
    if (!headers.containsKey(HeaderField.name)) {
      Config.showAlertDialog("Нажмите сохранить вверху экрана", context);
      return;
    }
    if (!headers.containsKey(HeaderField.faceImageUrl)) {
      Config.showAlertDialog("Нажмите сохранить вверху экрана", context);
      return;
    }
    if (!headers.containsKey(HeaderField.cookTimeMins)) {
      Config.showAlertDialog("Нажмите сохранить вверху экрана", context);
      return;
    }
    if (!headers.containsKey(HeaderField.prepTimeMins)) {
      Config.showAlertDialog("Нажмите сохранить вверху экрана", context);
      return;
    }
    if (ingredients.isEmpty) {
      Config.showAlertDialog("У рецепта должны быть ингридиенты", context);
      return;
    }
    if (steps.isEmpty) {
      Config.showAlertDialog("У рецепта должен быть хотя бы один шаг", context);
      return;
    }
    createdRecipe = Recipe(
      isNetwork: true,
        name: headers[HeaderField.name],
        faceImageUrl: headers[HeaderField.faceImageUrl],
        id: Random().nextInt(1000),
        cookTimeMins: headers[HeaderField.cookTimeMins],
        prepTimeMins: headers[HeaderField.prepTimeMins],
        kilocalories: 0,
        ingredients: ingredients,
        steps: steps,);
    Config.showAlertDialog("Ваш рецепт был успешно сохранен!", context);
    setState(() {
    });
  }

  List<Widget> allLabels(BuildContext context) {
    var labels = <Widget>[
      HeaderLabel(
        headers: headers,
      ),
      IngredientsLabel(insertList: ingredients),
      StepsLabel(
        insertList: steps,
      ),
      Container(
        margin: Config.paddingAll,
        child: SizedBox(
            width: CreateRecipeScreen.pageWidth(context) / 2,
            child: SizedBox(
                child: ClassicButton(
                  customColor: CreateRecipeScreen.buttonColor,
              onTap: submitRecipe,
              text: "Сохранить рецепт",
              fontSize: CreateRecipeScreen.generalFontSize(context),
            ))),
      ),
    ];
    if (createdRecipe != null) {
      labels.add(
        Container(
          margin: Config.paddingAll,
          child: SizedBox(
              width: CreateRecipeScreen.pageWidth(context) / 2,
              child: SizedBox(
                  child: ClassicButton(
                    customColor: CreateRecipeScreen.buttonColor,
                    onTap: showCreatedRecipe,
                    text: "Превью",
                    fontSize: CreateRecipeScreen.generalFontSize(context),
                  ))),
        ),
      );
    }
    return labels.map((e) => roundWrapper(e)).toList();
  }

  void showCreatedRecipe() {
    if (createdRecipe == null) {
      Config.showAlertDialog("Рецепт не создан", context);
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context)
    => RecipeScreen(recipe: createdRecipe!)));
  }

  Container roundWrapper(Widget child) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge,
          color: labelColor.withOpacity(.9),
          border: Config.darkModeOn
              ? null
              : Border.all(color: Colors.black87, width: 0.3)),
      padding: Config.paddingAll,
      margin: const EdgeInsets.only(bottom: Config.margin),
      child: child,
    );
  }

  TextStyle get ingStyle => TextStyle(
      color: Config.iconColor,
      fontFamily: Config.fontFamily,
      fontSize: CreateRecipeScreen.generalFontSize(context));
}
