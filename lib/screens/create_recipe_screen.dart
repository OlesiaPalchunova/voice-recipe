import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/buttons/button.dart';
import 'package:voice_recipe/components/drop_zone.dart';
import 'package:voice_recipe/components/login/input_label.dart';
import 'package:voice_recipe/model/dropped_file.dart';

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
  final stepController = TextEditingController();
  final waitTimeController = TextEditingController();
  final List<Ingredient> ingredients = [];
  final List<RecipeStep> steps = [];

  @override
  void dispose() {
    nameController.dispose();
    ingNameController.dispose();
    ingCountController.dispose();
    stepController.dispose();
    waitTimeController.dispose();
    super.dispose();
  }

  Color get backgroundColor =>
      Config.darkModeOn ? Config.backgroundColor : ClassicButton.buttonColor;

  Color get labelColor =>
      !Config.darkModeOn ? Config.backgroundColor : ClassicButton.buttonColor;

  double pageWidth(BuildContext context) => Config.recipeSlideWidth(context);

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
    var labels = <Widget>[
      enterNameLabel(context),
      ingredientsLabel(context),
      stepsLabel(context)
    ];
    return labels.map((e) => roundWrapper(e)).toList();
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
              hintText: "Введите название рецепта", controller: nameController),
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
              fontSize: titleFontSize(context))),
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
            children: steps
                .map((step) => Container(
                decoration: BoxDecoration(
                    color: Config.backgroundColor,
                    borderRadius: Config.borderRadiusLarge
                ),
                padding: Config.paddingAll,
                margin: const EdgeInsets.only(bottom: Config.margin),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: Config.borderRadiusLarge,
                        child: Image(
                          image: NetworkImage(step.imgUrl),
                          fit: BoxFit.fitWidth,
                        )),
                    const SizedBox(
                      height: Config.padding,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Шаг ${step.id}",
                        style: ingStyle,
                      ),
                    ),
                    const SizedBox(
                      height: Config.padding,
                    ),
                    Text(
                      step.description,
                      style: TextStyle(
                        color: Config.iconColor,
                        fontFamily: Config.fontFamily,
                        fontSize: 16
                      ),
                    )
                  ],
                )))
                .toList(),
          ),
        ),
        Container(
          padding: Config.paddingAll,
          child: Column(
            children: [
              DropZone(
                onDrop: handleDropFile,
              ),
              const SizedBox(
                height: Config.padding,
              ),
              InputLabel(
                  hintText: "Введите описание шага",
                  controller: stepController),
              const SizedBox(
                height: Config.padding,
              ),
              InputLabel(
                  hintText: "Время ожидания, в минутах (опционально)",
                  controller: waitTimeController),
              const SizedBox(
                height: Config.padding,
              ),
              stepImagePreview(),
              const SizedBox(
                height: Config.padding,
              ),
              ClassicButton(onTap: addNewStep, text: "Добавить этот шаг")
            ],
          ),
        ),
      ],
    );
  }

  Widget stepImagePreview() {
    if (currentImageFile == null) {
      return Container();
    }
    return ClipRRect(
        borderRadius: Config.borderRadiusLarge,
        child: Image(
          image: NetworkImage(currentImageFile!.url),
          fit: BoxFit.fitWidth,
        ));
  }

  DroppedFile? currentImageFile;

  void handleDropFile(DroppedFile file) {
    setState(() {
      currentImageFile = file;
    });
  }

  Widget ingredientsLabel(BuildContext context) {
    return Column(children: [
      title(context, "Ингредиенты"),
      const SizedBox(
        height: Config.padding,
      ),
      Container(
        padding: Config.paddingAll,
        child: Column(
          children: ingredients
              .map((e) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.name,
                    style: ingStyle,
                  ),
                  Text(
                    e.count,
                    style: ingStyle,
                  )
                ],
              ),
              Divider(
                color: Config.iconColor.withOpacity(0.5),
                thickness: 0.3,
              )
            ],
          ),
          )
              .toList(),
        ),
      ),
      Container(
        padding: Config.paddingAll,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: pageWidth(context) * .3,
            child:
                InputLabel(hintText: "Название", controller: ingNameController),
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
              child: ClassicButton(onTap: addNewIngredient, text: "Добавить"))
        ]),
      ),
    ]);
  }

  TextStyle get ingStyle => TextStyle(
      color: Config.iconColor,
      fontFamily: Config.fontFamily,
      fontSize: generalFontSize(context));

  void addNewStep() {
    if (currentImageFile == null) {
      Config.showAlertDialog(
          "К шагу должно быть приложено изображение", context);
      return;
    }
    String desc = stepController.text.trim();
    String waitTimeStr = waitTimeController.text.trim();
    if (desc.isEmpty) {
      Config.showAlertDialog("Описание не может быть пустым", context);
      return;
    }
    int waitTimeFinal = 0;
    if (waitTimeStr.isNotEmpty) {
      int? waitTime = int.tryParse(waitTimeStr);
      if (waitTime == null) {
        Config.showAlertDialog(
            "Время ожидания должно быть числом минут", context);
        return;
      }
      if (waitTime > 24 * 60) {
        Config.showAlertDialog(
            "Время ожидания не может превышать сутки", context);
        return;
      }
      waitTimeFinal = waitTime;
    }
    stepController.clear();
    waitTimeController.clear();
    setState(() {
      steps.add(RecipeStep(
          waitTime: waitTimeFinal,
          id: steps.length + 1,
          imgUrl: currentImageFile!.url,
          description: desc));
      currentImageFile = null;
    });
  }

  void addNewIngredient() {
    String ingName = ingNameController.text.trim();
    String ingCount = ingCountController.text.trim();
    if (ingName.isEmpty | ingCount.isEmpty) {
      Config.showAlertDialog(
          "Ингредиент или его количество\n"
          "не может быть пустым",
          context);
      return;
    }
    ingNameController.clear();
    ingCountController.clear();
    setState(() {
      ingredients.add(
          Ingredient(id: ingredients.length, name: ingName, count: ingCount));
    });
  }
}
