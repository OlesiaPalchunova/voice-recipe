import 'package:flutter/material.dart';
import 'package:voice_recipe/model/comments_model.dart';
import 'package:voice_recipe/model/db/comment_db_manager.dart';

import '../../config.dart';
import '../../model/users_info.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.commentId, required this.comment, required this.recipeId,
  required this.onDelete});

  final String commentId;
  final Comment comment;
  final int recipeId;
  final VoidCallback onDelete;

  static double nameFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 16 : 14;

  static double descFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 16 : 14;

  static double sinceFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 14 : 12;

  String get since {
    var diff = DateTime.now().difference(comment.postTime);
    if (diff.inMinutes < 60) {
      if (diff.inMinutes == 0) {
        return "только что";
      }
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

  Widget buildCommentFrame(
      {required BuildContext context,
      String nickname = "",
      String since = "",
      String profileImageUrl = defaultProfileUrl,
      required Widget body}) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      margin: const EdgeInsets.symmetric(vertical: Config.margin),
      decoration: const BoxDecoration(
          // color: Config.pressed,
          borderRadius: Config.borderRadius),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: Config.padding * 5),
          // .add(const EdgeInsets.symmetric(vertical: Config.padding)),
          child: Column(
            children: [
              nickname.isNotEmpty
                  ? Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            nickname,
                            style: TextStyle(
                                color: Config.iconColor,
                                fontFamily: Config.fontFamily,
                                fontSize: nameFontSize(context)),
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
                                fontSize: sinceFontSize(context)),
                          ),
                        ),
                      ],
                    )
                  : Container(),
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
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<int>(
            color: Config.backgroundColor,
            tooltip: '',
            itemBuilder: (context) => getCommentOptions(),
            icon: Icon(
              Icons.more_vert,
              color: Config.iconColor,
            ),
          ),
        )
      ]),
    );
  }

  List<PopupMenuEntry<int>> getCommentOptions() {
    if (!Config.loggedIn) {
      return <PopupMenuEntry<int>>[
        PopupMenuItem(value: 1, child: getOption("Пожаловаться"),),
      ];
    }
    String uid = Config.user!.uid;
    if (comment.uid == uid) {
      return <PopupMenuEntry<int>>[
        PopupMenuItem(value: 1, child: getOption("Редактировать")),
        PopupMenuItem(value: 2,
        onTap: deleteComment, child: getOption("Удалить"),),
      ];
    }
    return <PopupMenuEntry<int>>[
      PopupMenuItem(value: 1, child: getOption("Пожаловаться"),),
    ];
  }

  Future deleteComment() async {
    await CommentDbManager().deleteComment(recipeId, commentId);
    onDelete();
  }

  Widget getOption(String name) {
    return Container(
      color: Config.backgroundColor,
      child: Text(name,
      style: TextStyle(
          fontFamily: Config.fontFamily,
          fontSize: 16,
        color: Config.iconColor
      ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCommentFrame(
      context: context,
      nickname: comment.userName,
      since: since,
      profileImageUrl: comment.profileUrl,
      body: Container(
        alignment: Alignment.topLeft,
        child: Text(
          comment.text,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Config.iconColor.withOpacity(0.9),
              fontFamily: Config.fontFamily,
              fontSize: descFontSize(context)),
        ),
      ),
    );
  }
}
