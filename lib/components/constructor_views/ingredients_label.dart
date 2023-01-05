import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/delete_button.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';
import '../../screens/create_recipe_screen.dart';
import '../buttons/classic_button.dart';
import '../labels/input_label.dart';

class IngredientsLabel extends StatefulWidget {
  const IngredientsLabel({super.key, required this.insertList});

  final List<Ingredient> insertList;

  @override
  State<IngredientsLabel> createState() => IngredientsLabelState();
}

class IngredientsLabelState extends State<IngredientsLabel> {
  final ingNameController = TextEditingController();
  final ingCountController = TextEditingController();
  final nameFocusNode = FocusNode();
  static const examples = [
    "400 гр.", "1 щепотка", "2 ст. л.", "3 шт."
  ];
  static final regExp = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");
  static final random = Random();
  static IngredientsLabelState? current;

  String get example => examples[random.nextInt(examples.length)];

  @override
  void initState() {
    current = this;
    super.initState();
  }

  @override
  void dispose() {
    current = null;
    ingNameController.dispose();
    ingCountController.dispose();
    super.dispose();
  }

  void clear() {
    if (current == null) return;
    ingNameController.clear();
    ingCountController.clear();
    widget.insertList.clear();
    setState(() {});
  }

  Widget buildIngredient(Ingredient ingredient) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ingredient.name,
              style: ingStyle,
            ),
            Row(
              children: [
                Text(
                  "${ingredient.count} ${ingredient.measureUnit}",
                  style: ingStyle,
                ),
                const SizedBox(width: Config.margin * 2,),
                DeleteButton(
                  margin: const EdgeInsets.symmetric(horizontal:
                  Config.margin),
                  onPressed: () {
                  for (Ingredient other in widget.insertList) {
                    if (other.id > ingredient.id) {
                      other.id--;
                    }
                  }
                  setState(() {
                    widget.insertList.remove(ingredient);
                  });
                }, toolTip: "Убрать ингридиент",)
              ],
            )
          ],
        ),
        Divider(
          color: Config.iconColor.withOpacity(0.5),
          thickness: 0.3,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CreateRecipeScreen.title(context, "Ингредиенты"),
      const SizedBox(
        height: Config.padding,
      ),
      Container(
        padding: Config.paddingAll,
        child: Column(
          children: widget.insertList.map(buildIngredient).toList(),
        ),
      ),
      Container(
        padding: Config.paddingAll,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: CreateRecipeScreen.pageWidth(context) * .3,
            child:
                InputLabel(labelText: "Название", controller: ingNameController,
                  fontSize: CreateRecipeScreen.generalFontSize(context),
                focusNode: nameFocusNode,),
          ),
          SizedBox(
            width: CreateRecipeScreen.pageWidth(context) * .3,
            child: InputLabel(
              labelText: "Количество",
              controller: ingCountController,
              fontSize: CreateRecipeScreen.generalFontSize(context),
              onSubmit: addNewIngredient,
            ),
          ),
          SizedBox(
              width: CreateRecipeScreen.pageWidth(context) * .3,
              child: ClassicButton(
                customColor: CreateRecipeScreen.buttonColor, onTap: addNewIngredient, text: "Добавить",
    fontSize: CreateRecipeScreen.generalFontSize(context),))
        ]),
      ),
    ]);
  }

  TextStyle get ingStyle => TextStyle(
      color: Config.iconColor,
      fontFamily: Config.fontFamily,
      fontSize: CreateRecipeScreen.generalFontSize(context));

  String get errorMsg => "Введено недопустимое количество\n"
      "Вначале введите число, а затем единицу измерения\n"
      "Пример: $example";

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
    var countStr = ingCount.split(' ').first;
    double? count = double.tryParse(countStr);
    String unitStr = ingCount.replaceAll(regExp, '').trim();
    if (count == null) {
      Config.showAlertDialog(
          errorMsg,
          context);
      return;
    }
    if (unitStr.isEmpty) {
      Config.showAlertDialog(
          errorMsg,
          context);
      return;
    }
    ingNameController.clear();
    ingCountController.clear();
    setState(() {
      nameFocusNode.requestFocus();
      widget.insertList.add(Ingredient(
          id: widget.insertList.length, name: ingName, measureUnit: unitStr,
      count: count));
    });
  }
}
