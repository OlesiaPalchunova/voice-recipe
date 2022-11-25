import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/review/rate_label.dart';
import 'package:voice_recipe/components/review/comment_card.dart';
import 'package:voice_recipe/components/review/star_panel.dart';
import 'package:voice_recipe/model/reviews_info.dart';
import 'package:voice_recipe/screens/login_screen.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';
import '../../model/users_info.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  var _isEvaluated = false;
  final _commentController = TextEditingController();

  @override
  initState() {
    super.initState();
    int? rate = ratesMap[widget.recipe.id];
    if (rate != null) {
      _isEvaluated = true;
    }
  }

  @override
  dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backColor = Config.darkModeOn ? Colors.black12 : Colors.white;
    final Color color = Config.iconColor.withOpacity(0.8);
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
                    color: backColor,
                    borderRadius:
                        BorderRadius.circular(Config.borderRadiusLarge)),
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
                              fontSize: 22,
                              color: Config.iconColor),
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
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: Config.padding),
                // padding: const EdgeInsets.all(Config.padding),
                decoration: BoxDecoration(
                    color: backColor,
                    borderRadius:
                        BorderRadius.circular(Config.borderRadiusLarge)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Config.padding),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Комментарии",
                        style: TextStyle(
                            color:
                                Config.darkModeOn ? Colors.white : Colors.black,
                            fontFamily: Config.fontFamily,
                            fontSize: 22),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          CommentCard.buildCommentFrame(
                              body: TextField(
                                controller: _commentController,
                            style: TextStyle(color: color, fontFamily: Config.fontFamily),
                            onTap: () {
                              if (Config.loggedIn) {
                                return;
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                            },
                            onSubmitted: (String result) {
                              if (result.isEmpty || !Config.loggedIn) {
                                return;
                              }
                              for (var element in users) {
                                debugPrint(element.name);
                              }
                              reviews[widget.recipe.id].add(
                                Review(userId: users[users.length - 1].id,
                                    postTime: DateTime.now(),
                                    text: result
                                )
                              );
                              setState(() {
                                _commentController.clear();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Оставьте свой комментарий',
                              hintStyle: TextStyle(color: color, fontFamily: Config.fontFamily),
                            ),
                          )),
                          Column(
                            children: reviews[widget.recipe.id]
                                .map((e) => CommentCard(
                                      review: e,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
