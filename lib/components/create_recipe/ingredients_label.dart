import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/delete_button.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';
import '../../screens/create_recipe_screen.dart';
import '../buttons/classic_button.dart';
import '../login/input_label.dart';

class IngredientsLabel extends StatefulWidget {
  const IngredientsLabel({super.key, required this.insertList});

  final List<Ingredient> insertList;

  @override
  State<IngredientsLabel> createState() => _IngredientsLabelState();
}

class _IngredientsLabelState extends State<IngredientsLabel> {
  final ingNameController = TextEditingController();
  final ingCountController = TextEditingController();

  @override
  void dispose() {
    ingNameController.dispose();
    ingCountController.dispose();
    super.dispose();
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
                  ingredient.count,
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
                InputLabel(hintText: "Название", controller: ingNameController,
                  fontSize: CreateRecipeScreen.generalFontSize(context),),
          ),
          SizedBox(
            width: CreateRecipeScreen.pageWidth(context) * .3,
            child: InputLabel(
              hintText: "Количество",
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
      widget.insertList.add(Ingredient(
          id: widget.insertList.length, name: ingName, count: ingCount));
    });
  }
}
