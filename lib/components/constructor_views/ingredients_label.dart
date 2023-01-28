import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/delete_button.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';
import '../../pages/constructor/create_recipe_page.dart';
import '../buttons/classic_button.dart';
import '../labels/input_label.dart';

class CreateIngredientsLabel extends StatefulWidget {
  const CreateIngredientsLabel({super.key, required this.insertList,
  required this.ingNameFocusNode, required this.ingCountFocusNode});

  final List<Ingredient> insertList;
  final FocusNode ingNameFocusNode;
  final FocusNode ingCountFocusNode;

  @override
  State<CreateIngredientsLabel> createState() => CreateIngredientsLabelState();
}

class CreateIngredientsLabelState extends State<CreateIngredientsLabel> {
  final ingNameController = TextEditingController();
  final ingCountController = TextEditingController();
  static const countExamples = [
    "400 гр.", "1 щепотка", "2 ст. л.", "3 шт."
  ];
  static final examples = [
    Ingredient(id: 0, name: "Клубника", count: 50, measureUnit: "гр."),
    Ingredient(id: 0, name: "Банан", count: 2, measureUnit: "шт."),
    Ingredient(id: 0, name: "Молоко", count: 500, measureUnit: "мл."),
    Ingredient(id: 0, name: "Паприка", count: 1.5, measureUnit: "ст. л."),
  ];
  static final regExp = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");
  static final random = Random();
  static CreateIngredientsLabelState? current;

  String get countExample => countExamples[random.nextInt(countExamples.length)];

  Ingredient get example => examples[random.nextInt(examples.length)];

  late Ingredient ing;

  @override
  void initState() {
    ing = example;
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

  final zeroRegex = RegExp(r'([.]*0)(?!.*\d)');

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
                  "${ingredient.count.toString().replaceAll(zeroRegex, '')} ${ingredient.measureUnit}",
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
    bool showHint = widget.insertList.isEmpty;
    String count = '${ing.count.toString().replaceAll(zeroRegex, '')} ${ing.measureUnit}';
    return Column(children: [
      CreateRecipePage.title(context, "Ингредиенты"),
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
            width: CreateRecipePage.pageWidth(context) * .3,
            child:
                InputLabel(
                  labelText: "Название",
                  hintText: showHint ? ing.name : null,
                  controller: ingNameController,
                  fontSize: CreateRecipePage.generalFontSize(context),
                focusNode: widget.ingNameFocusNode,
                ),
          ),
          SizedBox(
            width: CreateRecipePage.pageWidth(context) * .3,
            child: InputLabel(
              labelText: "Количество",
              hintText: showHint ? count : null,
              focusNode: widget.ingCountFocusNode,
              controller: ingCountController,
              fontSize: CreateRecipePage.generalFontSize(context),
              onSubmit: addNewIngredient,
            ),
          ),
          SizedBox(
              width: CreateRecipePage.pageWidth(context) * .3,
              child: ClassicButton(
                customColor: CreateRecipePage.buttonColor, onTap: addNewIngredient, text: "Добавить",
    fontSize: CreateRecipePage.generalFontSize(context),))
        ]),
      ),
    ]);
  }

  TextStyle get ingStyle => TextStyle(
      color: Config.iconColor,
      fontFamily: Config.fontFamily,
      fontSize: CreateRecipePage.generalFontSize(context));

  String get errorMsg => "Введено недопустимое количество\n"
      "Вначале введите число, а затем единицу измерения\n"
      "Пример: $countExample";

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
      widget.ingNameFocusNode.requestFocus();
      widget.insertList.add(Ingredient(
          id: widget.insertList.length, name: ingName, measureUnit: unitStr,
      count: count));
    });
  }
}
