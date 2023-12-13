import 'package:flutter/material.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';
import 'package:voice_recipe/services/db/category_db.dart';

import '../components/constructor_views/category_label.dart';


class CategoryModel extends StatelessWidget {
  const CategoryModel({super.key, required this.id, required this.name, this.color});

  final int id;
  final String name;
  final Color? color;

  // void confirmRemoving(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(""),
  //       )
  //   )
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: name.length*9+30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color ?? Colors.deepOrange[100]
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(name),
              ),
            ),
            GestureDetector(
              onTap: () {
                // CategoryDB().deleteRecipeFromCategory(recipe_id: recipe_id, category_id: id);
                RecipeHeaderCard.delete(context, id);
                if (color != null) CategoryLabel.removeCategory(context, id, name);
                print("close");
              },
              child: Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
