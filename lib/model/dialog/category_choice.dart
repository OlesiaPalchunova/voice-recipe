import 'package:flutter/material.dart';
import 'package:voice_recipe/components/constructor_views/category_label.dart';
import 'package:voice_recipe/model/collections_info.dart';
import 'package:voice_recipe/services/db/category_db.dart';

import '../../services/db/collection_db.dart';
import '../category_model.dart';
import '../collection_model.dart';
import '../sets_info.dart';

class CategoryChoice extends StatefulWidget {
  final Map<int, Collection> allCategories;
  final List<CategoryModel> categories;
  final int recipe_id;
  final Color category_color;

  CategoryChoice({required this.allCategories, required this.recipe_id, required this.categories, this.category_color = Colors.deepOrangeAccent});

  @override
  _CategoryChoiceState createState() => _CategoryChoiceState();
}

class _CategoryChoiceState extends State<CategoryChoice> {
  List<bool> _isChecked = List<bool>.generate(1000, (index) => false);
  List<Collection> categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.allCategories.forEach((key, value) {
      categories.add(widget.allCategories[key]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    return AlertDialog(
      title: Center(
          child: Text("Выберите категории")
      ),
      content: Container(
        height: 300,
        width: 150,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(categories[index].name),
              value: _isChecked[index],
              onChanged: (bool? newValue) {
                setState(() {
                  _isChecked[index] = !_isChecked[index];
                });
              },
              activeColor: Colors.deepOrangeAccent,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              tristate: true,
            );
          },
        ),
      ),
      actions: <Widget>[
        Center(
          child: Container(
            width: 100,
            child: ElevatedButton(
              onPressed: () async {
                for (int i = 0; i < categories.length; i++) {
                  if (!_isChecked[i]) continue;
                  print(i);
                  widget.categories.add(CategoryModel(id: categories[i].id, name: categories[i].name, color: widget.category_color,));
                  if (widget.recipe_id != -1) await CategoryDB.addRecipeToCategory(recipe_id: widget.recipe_id, category_id: categories[i].id);
                  print("add");
                }
                // else {
                //   await CategoryLabel.updateCategories(context, _isChecked, categories);
                // }

                Navigator.of(context).pop();
              },
              child: Center(
                  child: Text("Выбрать")
              ),
            ),
          ),
        ),
      ],
    );
  }
}


