import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/buttons/button.dart';
import 'package:voice_recipe/components/login/input_label.dart';

import '../config.dart';
import '../model/recipes_info.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final nameController = TextEditingController();
  final ingNameController = TextEditingController();
  final ingCountController = TextEditingController();
  final List<Ingredient> ingredients = [];

  @override
  void dispose() {
    nameController.dispose();
    ingNameController.dispose();
    ingCountController.dispose();
    super.dispose();
  }

  Color get backgroundColor => Config.darkModeOn ?
    Config.backgroundColor : ClassicButton.buttonColor;

  Color get labelColor => !Config.darkModeOn ?
  Config.backgroundColor : ClassicButton.buttonColor;

  double pageWidth(BuildContext context)
    => Config.recipeSlideWidth(context);

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
                image: AssetImage("assets/images/decorations/wood.jpg"),
                fit: BoxFit.cover
            )
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: Config.margin * 2),
            alignment: Alignment.topCenter,
            width: pageWidth(context),
            child: SingleChildScrollView(
              child: Column(
                children: allLabels(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> allLabels(BuildContext context) {
    var labels = <Widget>[enterNameLabel(context), ingredientsLabel(context),
    stepsLabel(context)];
    return labels.map((e) => roundWrapper(e)).toList();
  }

  Container roundWrapper(Widget child) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge,
          color: labelColor.withOpacity(.9),
          border: Config.darkModeOn ? null : Border.all(
            color: Colors.black87,
            width: 0.3
          )
      ),
      padding: Config.paddingAll,
      margin: const EdgeInsets.only(bottom: Config.margin),
      child: child,
    );
  }

  double generalFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 20 : 18;

  double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 21 : 19;

  Widget enterNameLabel(BuildContext context) {
    return Column(
      children: [
        title(context, "Название рецепта"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: InputLabel(
              hintText: "Введите название рецепта", controller: nameController
          ),
        )
      ],
    );
  }

  Widget title(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.only(left: Config.padding),
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: TextStyle(
              fontFamily: Config.fontFamily,
              color: Config.iconColor,
              fontSize: titleFontSize(context)
          )
      ),
    );
  }

  Widget stepsLabel(BuildContext context) {
    return Column(
      children: [
        title(context, "Шаги"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: Column(
            children: [
              buildDropZone(context)
            ],
          ),
        )
      ],
    );
  }

  Widget ingredientsLabel(BuildContext context) {
    return Column(
      children: [
        title(context, "Ингредиенты"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: pageWidth(context) * .3,
                child: InputLabel(
                    hintText: "Название", controller: ingNameController),
              ),
              SizedBox(
                width: pageWidth(context) * .3,
                child: InputLabel(
                  hintText: "Количество",
                  controller: ingCountController,
                ),
              ),
              SizedBox(
                width: pageWidth(context) * .3,
                child: ClassicButton(
                    onTap: addNewIngredient,
                    text: "Добавить"
                )
              )
            ]
          ),
        ),
        Container(
          padding: Config.paddingAll,
          child: Column(
            children: ingredients.map((e) => Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.name, style: ingStyle,),
                      Text(e.count, style: ingStyle,)
                    ],
                  ),
                  Divider(
                    color: Config.iconColor.withOpacity(0.5),
                    thickness: 0.3,
                  )
                ],
              ),
            )).toList(),
          ),
        )
      ]
    );
  }

  TextStyle get ingStyle => TextStyle(
    color: Config.iconColor,
    fontFamily: Config.fontFamily,
    fontSize: generalFontSize(context)
  );

  void addNewIngredient() {
    String ingName = ingNameController.text.trim();
    String ingCount = ingCountController.text.trim();
    if (ingName.isEmpty | ingCount.isEmpty) {
      Config.showAlertDialog("Ингредиент или его количество\n"
          "не может быть пустым", context);
      return;
    }
    ingNameController.clear();
    ingCountController.clear();
    setState(() {
      ingredients.add(Ingredient(id: ingredients.length, name: ingName,
          count: ingCount));
    });
  }

  Widget buildDropZone(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: Config.borderRadiusLarge,
      ),
      height: 200,
      padding: Config.paddingAll,
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Config.iconColor.withOpacity(.7),
        strokeWidth: 3,
        radius: const Radius.circular(Config.largeRadius),
        dashPattern: const [8, 4],
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload,
                color: Config.iconColor,
                size: 40,
              ),
              Text(
                "Перетащите изображение сюда",
                style: ingStyle,
              ),
              const SizedBox(height: Config.padding,),
              SizedBox(
                  width: pageWidth(context) * .3,
                  child: ClassicButton(onTap: () {}, text: "Выбрать файл")
              )
            ],
          ),
        ),
      ),
    );
  }
}
