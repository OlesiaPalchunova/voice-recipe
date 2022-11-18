import 'package:flutter/material.dart';
import 'package:voice_recipe/components/review/star_panel.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  var _isEvaluated = false;
  var _starsCount = 0;

  @override
  initState() {
    super.initState();
    int? rate = ratesMap[widget.recipe.id];
    if (rate != null) {
      _isEvaluated = true;
      _starsCount = rate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(
          Config.padding, Config.padding, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: _buildRate(),
              ),
              Container(
                margin: const EdgeInsets.only(top: Config.padding),
                alignment: Alignment.centerLeft,
                child: Text(
                  !_isEvaluated ? "Оставьте отзыв" : "Готово",
                  style: TextStyle(
                    fontFamily: Config.fontFamily,
                    fontSize: 28,
                    color: Config.iconColor
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Config.padding),
                child: StarPanel(
                  onTap: (star) {
                    setState(() {
                      _isEvaluated = true;
                    });
                    ratesMap[widget.recipe.id] = star;
                  },
                  activeStarsCount: _starsCount,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRate() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Config.borderRadiusLarge)),
      width: 80,
      padding: const EdgeInsets.all(Config.padding / 2),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.yellow,
            size: 30,
          ),
          Text(
            rates[widget.recipe.id].toString(),
            style: const TextStyle(
                fontFamily: Config.fontFamily,
                color: Colors.black87,
                fontSize: 22),
          )
        ],
      ),
    );
  }
}
