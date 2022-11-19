import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/model/reviews_info.dart';

import '../../config.dart';
import '../../model/users_info.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    User user = users[review.userId - 1];
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      margin: const EdgeInsets.symmetric(vertical: Config.margin),
      decoration: BoxDecoration(
          // color: Config.pressed,
          borderRadius: BorderRadius.circular(Config.borderRadius)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Config.padding * 3),
            // .add(const EdgeInsets.symmetric(vertical: Config.padding)),
            child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  user.name,
                  style: TextStyle(
                      color: Config.iconColor.withOpacity(0.7),
                      fontFamily: Config.fontFamily,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: Config.padding,),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  review.text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Config.iconColor,
                      fontFamily: Config.fontFamily,
                      fontSize: 16),
                ),
              )
            ],
        ),
          ),
          CircleAvatar(
            radius: Config.padding,
            backgroundColor: Config.pressed,
            backgroundImage: AssetImage(user.imageProfileUrl),
          ),
      ]
      ),
    );
  }
}
