import 'package:flutter/material.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config.dart';

class MiniIngredientsList extends StatefulWidget {
  const MiniIngredientsList({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<MiniIngredientsList> createState() => MiniIngredientsListState();
}

class MiniIngredientsListState extends State<MiniIngredientsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _growAnimation;
  late final double _height = widget.recipe.ingredients.length * 35.0;
  static const int _animationTimeMillis = 400;
  static MiniIngredientsListState? current;
  final zeroRegex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    current = this;
    super.initState();
    _controller = AnimationController(duration: const Duration(
        milliseconds: _animationTimeMillis), vsync: this);
  }

  @override
  void didChangeDependencies() {
    current = this;
    super.didChangeDependencies();
    _growAnimation = Tween(begin: 0.0, end: _height).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void moveOut() {
    assert(current != null);
    _controller.forward();
  }

  void moveBack() {
    assert(current != null);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _growAnimation,
      builder: (context, child) {
        return SizedBox(
          height: _growAnimation.value,
          child: child,
        );
      },
      child: Container(
          width: 240,
          padding: Config.paddingAll,
          decoration: BoxDecoration(
              color: Config.getBackEdgeColor(widget.recipe.id).withOpacity(.95),
              borderRadius: Config.borderRadiusLarge),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                  children: widget.recipe.ingredients
                      .map(buildIngredientView)
                      .toList()))),
    );
  }

  Widget buildIngredientView(Ingredient ingredient) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                ingredient.name,
                style: TextStyle(
                    color: Config.iconColor,
                    fontFamily: Config.fontFamily,
                    fontSize: 14),
              ),
            ),
            Text(
              "${ingredient.count.toString().replaceAll(zeroRegex, '')} ${ingredient.measureUnit}",
              style: TextStyle(
                  color: Config.iconColor,
                  fontFamily: Config.fontFamily,
                  fontSize: 14),
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
}
