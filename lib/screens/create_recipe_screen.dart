import 'dart:async';
import 'dart:math';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/api/recipes_sender.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/constructor_views/header_label.dart';
import 'package:voice_recipe/components/constructor_views/ingredients_label.dart';
import 'package:voice_recipe/components/constructor_views/steps_label.dart';
import 'package:voice_recipe/model/db/user_db_manager.dart';
import 'package:voice_recipe/screens/recipe_screen.dart';

import '../config.dart';
import '../model/recipes_info.dart';
import '../services/rive_utils.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  static const route = '/constructor';

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();

  static double generalFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

  static double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 19 : 17;

  static Color get buttonColor =>
      Config.darkModeOn ? const Color(0xff474645) : ClassicButton.color;

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
      Config.constructorWidth(context);
}

enum HeaderField { name, faceImageUrl, cookTimeMins, prepTimeMins }

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  static final List<Ingredient> ingredients = [];
  static final List<RecipeStep> steps = [];
  static final Map<HeaderField, dynamic> headers = {};

  @override
  void dispose() {
    super.dispose();
  }

  Color get backgroundColor => Config.backgroundColor;

  Color get labelColor =>
      !Config.darkModeOn ? Config.backgroundColor : ClassicButton.color;

  String get asset => Config.darkModeOn ? "green_balls" : "pink_balls";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(
        title: "Создать новый рецепт",
      ).appBar(),/**/
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Blur(
            blurColor: backgroundColor,
            blur: 3,
            child: RiveAnimation.asset("assets/RiveAssets/$asset.riv",
              artboard: "Motion",
              fit: Config.isDesktop(context) ?  BoxFit.fitWidth : BoxFit.fitHeight,
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
        ],
      ),
    );
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

  Recipe? createdRecipe;

  void submitRecipe() async {
    if (!Config.loggedIn) {
      Config.showLoginInviteDialog(context);
      return;
    }
    if (HeaderLabelState.current == null) {
      Config.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
      return;
    }
    bool gotHeaders = HeaderLabelState.current!.saveHeaders();
    if (!gotHeaders) {
      return;
    }
    if (ingredients.isEmpty) {
      Config.showAlertDialog("У рецепта должны быть ингредиенты", context);
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
      steps: steps,
    );
    Config.showProgressCircle(context);
    int recipeId = await RecipesSender().sendRecipe(createdRecipe!);
    await Future.microtask(() {
      Navigator.of(context).pop();
      if (recipeId == RecipesSender.fail) {
        Config.showAlertDialog(
            "Приносим свои извинения, сервер не отвечает", context);
      } else {
        UserDbManager().addNewCreated(Config.user!.uid, recipeId);
        Config.showAlertDialog(
            "Ваш рецепт был успешно сохранен!\n"
            "Вы всегда можете его просмотреть в разделе\n"
            "Профиль > Мои рецепты",
            context);
      }
    });
    if (HeaderLabelState.current == null) {
      Config.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
      return;
    }
    HeaderLabelState.current!.clear();
    if (IngredientsLabelState.current == null) {
      Config.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
      return;
    }
    IngredientsLabelState.current!.clear();
    if (StepsLabelState.current == null) {
      Config.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
      return;
    }
    StepsLabelState.current!.clear();
    setState(() {});
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RecipeScreen(recipe: createdRecipe!)));
  }

  TextStyle get ingStyle => TextStyle(
      color: Config.iconColor,
      fontFamily: Config.fontFamily,
      fontSize: CreateRecipeScreen.generalFontSize(context));
}
