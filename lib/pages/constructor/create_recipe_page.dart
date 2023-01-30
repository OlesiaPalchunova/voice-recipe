import 'dart:async';
import 'dart:math';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/api/recipes_sender.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/constructor_views/header_label.dart';
import 'package:voice_recipe/components/constructor_views/ingredients_label.dart';
import 'package:voice_recipe/components/constructor_views/steps_label.dart';
import 'package:voice_recipe/services/db/user_db_manager.dart';
import 'package:voice_recipe/components/utils/animated_loading.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../config/config.dart';
import '../../model/recipes_info.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  static const route = '/constructor';

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();

  static double generalFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 16 : 14;

  static double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

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

class _CreateRecipePageState extends State<CreateRecipePage> {
  static final List<Ingredient> ingredients = [];
  static final List<RecipeStep> steps = [];
  static final Map<HeaderField, dynamic> headers = {};
  final nameFocusNode = FocusNode();
  final ingNameFocusNode = FocusNode();
  final ingCountFocusNode = FocusNode();
  final descFocusNode = FocusNode();

  final int recipeId = 0;

  @override
  void dispose() {
    super.dispose();
  }

  Color get backgroundColor => Config.backgroundColor;

  Color get labelColor =>
      !Config.darkModeOn ? Colors.grey.shade300 : ClassicButton.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleLogoPanel(
        title: "Создать новый рецепт",
      ).appBar(),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () {
          nameFocusNode.unfocus();
          ingNameFocusNode.unfocus();
          ingCountFocusNode.unfocus();
          descFocusNode.unfocus();
        },
        child: Stack(
          children: [
            Blur(
              blur: Config.darkModeOn ? 3 : 1,
              blurColor: Config.darkThemeBackColor,
              child: Container(
                  decoration: Config.isWeb
                      ? const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/decorations/create_back.jpg'),
                              fit: BoxFit.cover))
                      : null),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: Config.margin * 2),
                  alignment: Alignment.topCenter,
                  width: CreateRecipePage.pageWidth(context),
                  child: Column(
                    children: allLabels(context),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container roundWrapper(Widget child) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge, color: labelColor),
      padding: Config.paddingAll,
      margin: const EdgeInsets.only(bottom: Config.margin),
      child: child,
    );
  }

  Recipe? createdRecipe;

  List<Widget> allLabels(BuildContext context) {
    var labels = <Widget>[
      CreateHeaderLabel(headers: headers, nameFocusNode: nameFocusNode),
      CreateIngredientsLabel(
        insertList: ingredients,
        ingNameFocusNode: ingNameFocusNode,
        ingCountFocusNode: ingCountFocusNode,
      ),
      CreateStepsLabel(insertList: steps, descFocusNode: descFocusNode),
      Container(
        margin: Config.paddingAll,
        alignment: Alignment.centerLeft,
        child: SizedBox(
            width: CreateRecipePage.pageWidth(context) / 2,
            child: SizedBox(
                child: ClassicButton(
              customColor: CreateRecipePage.buttonColor,
              onTap: submitRecipe,
              text: "Сохранить рецепт",
              fontSize: CreateRecipePage.generalFontSize(context),
            ))),
      ),
    ];
    return labels.map((e) => roundWrapper(e)).toList();
  }

  TextStyle get ingStyle => TextStyle(
      color: Config.iconColor,
      fontFamily: Config.fontFamily,
      fontSize: CreateRecipePage.generalFontSize(context));

  void submitRecipe() async {
    if (!ServiceIO.loggedIn) {
      ServiceIO.showLoginInviteDialog(context);
      return;
    }
    if (CreateHeaderLabelState.current == null) {
      ServiceIO.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
      return;
    }
    bool gotHeaders = CreateHeaderLabelState.current!.saveHeaders();
    if (!gotHeaders) {
      return;
    }
    if (ingredients.isEmpty) {
      ServiceIO.showAlertDialog("У рецепта должны быть ингредиенты", context);
      return;
    }
    if (steps.isEmpty) {
      ServiceIO.showAlertDialog("У рецепта должен быть хотя бы один шаг", context);
      return;
    }
    createdRecipe = Recipe(
      name: headers[HeaderField.name],
      faceImageUrl: headers[HeaderField.faceImageUrl],
      id: Random().nextInt(1000),
      cookTimeMins: headers[HeaderField.cookTimeMins],
      prepTimeMins: headers[HeaderField.prepTimeMins],
      kilocalories: 0,
      ingredients: ingredients,
      steps: steps,
    );
    AnimatedLoading().execute(context, task: () async {
      int recipeId = await RecipesSender().sendRecipe(createdRecipe!);
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (recipeId == RecipesSender.fail) {
          ServiceIO.showAlertDialog(
              "Приносим свои извинения, сервер не отвечает", context);
        } else {
          UserDbManager().addNewCreated(ServiceIO.user!.uid, recipeId);
        }
      });
      return recipeId != RecipesSender.fail;
    }, onSuccess: () {
      ServiceIO.showAlertDialog(
          "Ваш рецепт был успешно сохранен!\n"
          "Вы всегда можете его просмотреть в разделе\n"
          "Профиль > Мои рецепты",
          context);
      if (CreateHeaderLabelState.current == null) {
        ServiceIO.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
        return;
      }
      CreateHeaderLabelState.current!.clear();
      if (CreateIngredientsLabelState.current == null) {
        ServiceIO.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
        return;
      }
      CreateIngredientsLabelState.current!.clear();
      if (CreateStepsLabelState.current == null) {
        ServiceIO.showAlertDialog("Внутренняя ошибка, просим прощения.", context);
        return;
      }
      CreateStepsLabelState.current!.clear();
      setState(() {});
    });
  }
}
