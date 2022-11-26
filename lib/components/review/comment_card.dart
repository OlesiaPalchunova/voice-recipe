import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/model/reviews_info.dart';

import '../../config.dart';
import '../../model/users_info.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.review});

  final Review review;

  String get since {
    var diff = DateTime.now().difference(review.postTime);
    if (diff.inMinutes < 60) {
      int rest = diff.inMinutes - ((diff.inMinutes / 10).floor()) * 10;
      var str = "минут";
      if (rest == 1) {
        str = "минуту";
      } else if (rest < 5 && rest >= 1) {
        str = "минуты";
      }
      return "${diff.inMinutes} $str назад";
    }
    if (diff.inDays > 31) {
      int monthsCount = (diff.inDays / 30).floor();
      int rest = monthsCount - ((monthsCount / 10).floor()) * 10;
      var str = "месяцев";
      if (rest == 1) {
        str = "месяц";
      } else if (rest < 5) {
        str = "месяца";
      }
      return "$monthsCount $str назад";
    }
    return "${diff.inDays} дней назад";
  }

  static Widget buildCommentFrame(
      {String nickname = "",
      String since = "",
      String profileImageUrl = "assets/images/profile.png",
      required Widget body}) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      margin: const EdgeInsets.symmetric(vertical: Config.margin),
      decoration: BoxDecoration(
          // color: Config.pressed,
          borderRadius: BorderRadius.circular(Config.borderRadius)),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: Config.padding * 5),
          // .add(const EdgeInsets.symmetric(vertical: Config.padding)),
          child: Column(
            children: [
              nickname.isNotEmpty ? Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      nickname,
                      style: TextStyle(
                          color: Config.iconColor,
                          fontFamily: Config.fontFamily,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: Config.padding,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      since,
                      style: TextStyle(
                          color: Config.iconColor.withOpacity(0.7),
                          fontFamily: Config.fontFamily,
                          fontSize: 14),
                    ),
                  ),
                ],
              ) : Container(),
              const SizedBox(
                height: Config.padding,
              ),
              body
            ],
          ),
        ),
        CircleAvatar(
          radius: Config.padding * 2,
          backgroundColor: Config.pressed,
          backgroundImage: AssetImage(profileImageUrl),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCommentFrame(
      nickname: review.userName,
      since: since,
      profileImageUrl: review.profilePhotoURL,
      body: Container(
        alignment: Alignment.topLeft,
        child: Text(
          review.text,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Config.iconColor.withOpacity(0.9),
              fontFamily: Config.fontFamily,
              fontSize: 16),
        ),
      ),
    );
  }
}
