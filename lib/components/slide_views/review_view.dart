import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_recipe/components/review/RateLabel.dart';
import 'package:voice_recipe/components/review/star_panel.dart';
import 'package:voice_recipe/screens/login_screen.dart';

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

  @override
  initState() {
    super.initState();
    int? rate = ratesMap[widget.recipe.id];
    if (rate != null) {
      _isEvaluated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Config.margin),
      // color: Config.backgroundColor,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Config.padding),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: RateLabel(
                  rate: rates[widget.recipe.id],
                  width: min(90, Config.slideWidth(context) / 6),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Config.padding),
                padding: const EdgeInsets.all(Config.padding),
                decoration: BoxDecoration(
                  color: Config.darkModeOn ? Colors.black12 : Colors.white54,
                  borderRadius: BorderRadius.circular(Config.borderRadiusLarge)
                ),
                child: Column(
                  children: [
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          !_isEvaluated ? "Оставьте отзыв" : "Готово",
                          style: TextStyle(
                              fontFamily: Config.fontFamily,
                              fontSize: 28,
                              color: Config.iconColor),
                        ),
                        !_isEvaluated ? Container() :
                        InkWell(
                          onTap: () {
                            ratesMap.remove(widget.recipe.id);
                            setState(() {
                              StarPanelState.current?.clear();
                              _isEvaluated = false;
                            });
                          },
                          child: Text(
                            "Перезаписать ответ",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: Config.fontFamily,
                                fontSize: min(20, Config.slideWidth(context) / 30),
                                decoration: TextDecoration.underline,
                                color: Config.iconColor.withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Config.padding),
                      child: StarPanel(
                        id: widget.recipe.id,
                        onTap: (star) {
                          setState(() {
                            _isEvaluated = true;
                          });
                          ratesMap[widget.recipe.id] = star;
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Config.margin * 4),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:
                    (context) => const LoginScreen()
                    ));
                  },
                  child: Text(
                    "Оставить комментарий",
                    style: TextStyle(
                        fontFamily: Config.fontFamily,
                        fontSize: 28,
                        color: Config.iconColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
