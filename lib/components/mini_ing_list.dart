import 'package:flutter/material.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';

class MiniIngredientsList extends StatelessWidget {
    const MiniIngredientsList({super.key, required this.recipe});

    final Recipe recipe;

    @override
    Widget build(BuildContext context) {
        return Container(
                width: 200,
                padding: Config.paddingAll,
                decoration: BoxDecoration(
                    color: Config.getBackColor(recipe.id).withOpacity(.9),
                    borderRadius: Config.borderRadiusLarge
                ),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        children: recipe.ingredients.map(buildIngredientView).toList()
                    )
                )    
        );
    }

    Widget buildIngredientView(Ingredient ingredient) {
        return Column(
        children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(
                ingredient.name,
                style: TextStyle(
                    color: Config.iconColor,
                    fontFamily: Config.fontFamily,
                    fontSize: 12),
                ),
                Text(
                    "${ingredient.count} ${ingredient.measureUnit}",
                    style: TextStyle(
                    color: Config.iconColor,
                    fontFamily: Config.fontFamily,
                    fontSize: 12),
                )],
            ),
            Divider(
                color: Config.iconColor.withOpacity(0.5),
                thickness: 0.3,
            )
        ],
    );
  }
}
