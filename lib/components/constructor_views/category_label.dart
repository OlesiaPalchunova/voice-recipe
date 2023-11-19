import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../model/category_model.dart';
import '../../model/dialog/category_choice.dart';
import '../../model/recipes_info.dart';
import '../../model/sets_info.dart';
import '../../pages/constructor/create_recipe_page.dart';
import '../../services/db/category_db.dart';
import '../buttons/classic_button.dart';

class CategoryLabel extends StatefulWidget {
  CategoryLabel(
      {super.key, required this.categories});

  List<CategoryModel> categories;

  static Future removeCategory(BuildContext context, int id, String name) async {
    final state = context.findAncestorStateOfType<CategoryLabelState>();
    if (state != null) {
      state.removeCategory(id, name);
    }
  }

  @override
  State<CategoryLabel> createState() => CategoryLabelState();
}

class CategoryLabelState extends State<CategoryLabel> {
  // List<CategoryModel> categories = [];
  Map<int, Collection> allCategories = {};

  Future initCategories() async {
    Map<int, Collection> allCategories = await CategoryDB().getCategories();
    setState(() {
      this.allCategories = allCategories;

    });
  }

  @override
  void initState() {
    initCategories();
    super.initState();
  }

  void showCategories(BuildContext context) async {
    List<CategoryModel> newCategories = widget.categories;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryChoice(recipe_id: -1, allCategories: allCategories, categories: newCategories, category_color: Colors.white54,);
      },
    );
    setState(() {
      widget.categories = newCategories;
      for (var c in widget.categories) {
        print(c.id);
        if (allCategories.containsKey(c.id)) allCategories.remove(c.id);
      }
    });
    print(widget.categories.length);
  }

  void removeCategory(int id, String name) {
    setState(() {
      print("allCategories");
      widget.categories.removeWhere((element) => element.id == id);
      print("allCategories");
      allCategories[id] = Collection(id: id, name: name, collectionName: name);
      print("allCategories");
      print(allCategories.length);
    });
  }

  // void updateCategories(List<bool> _isChecked, List<Collection> restCategories) async {
  //   List<CategoryModel> categories = [];
  //   for (var c in categories) {
  //     print(c.id);
  //     if (allCategories.containsKey(c.id)) allCategories.remove(c.id);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateRecipePage.title(context, "Категории"),
        const SizedBox(
          height: Config.padding,
        ),
        Container(
          padding: Config.paddingAll,
          child: Column(
            children: [
              Wrap(
                spacing: 0.0,
                runSpacing: 0.0,
                children: [
                  for (var category in widget.categories) category,
                ],
              ),
              Container(
                margin: Config.paddingAll,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: CreateRecipePage.pageWidth(context) / 1.7,
                    child: SizedBox(
                        child: ClassicButton(
                          customColor: CreateRecipePage.buttonColor,
                          onTap: () {
                            showCategories(context);
                          },
                          text: "Добавить категорию",
                          fontSize: CreateRecipePage.generalFontSize(context),
                        ))),
              ),
            ],
          ),
        ),

      ],
    );
  }

}
