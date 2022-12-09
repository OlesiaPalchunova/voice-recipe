import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/review/new_comment_card.dart';
import 'package:voice_recipe/components/review/rate_label.dart';
import 'package:voice_recipe/components/review/comment_card.dart';
import 'package:voice_recipe/components/review/star_panel.dart';
import 'package:voice_recipe/model/comments_model.dart';
import 'package:voice_recipe/model/db/comment_db_manager.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';
import '../../model/users_info.dart';

class ReviewsSlide extends StatefulWidget {
  ReviewsSlide({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<ReviewsSlide> createState() => _ReviewsSlideState();

  final Map<String, Comment> comments = {};

  Future updateComments() async {
    var commentsDb = await CommentDbManager().getComments(recipe.id);
    comments.addEntries(commentsDb.entries);
  }
}

class _ReviewsSlideState extends State<ReviewsSlide> {
  var _isEvaluated = false;
  final _commentController = TextEditingController();
  final FocusNode _newCommentNode = FocusNode();
  bool _disposed = false;

  double fontSize(BuildContext context) => Config.isDesktop(context) ? 20 : 18;

  @override
  initState() {
    super.initState();
    _disposed = false;
    int? rate = ratesMap[widget.recipe.id];
    if (rate != null) {
      _isEvaluated = true;
    }
  }

  @override
  dispose() {
    _disposed = true;
    _commentController.dispose();
    super.dispose();
  }

  double get labelWidth => min(65, Config.recipeSlideWidth(context) / 6);

  @override
  Widget build(BuildContext context) {
    final Color backColor = Config.darkModeOn ? Colors.black12 : Colors.white;
    return GestureDetector(
      onTap: () => _newCommentNode.unfocus(),
      child: Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RateLabel(
                      rate: rates[widget.recipe.id],
                      width: labelWidth,
                      shadowOn: false,
                    ),
                    Container()
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: Config.padding),
                  padding: const EdgeInsets.all(Config.padding),
                  decoration: BoxDecoration(
                      color: backColor, borderRadius: Config.borderRadiusLarge),
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
                                fontSize: fontSize(context),
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
                      color: backColor, borderRadius: Config.borderRadiusLarge),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Config.padding),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Комментарии",
                          style: TextStyle(
                              color: Config.darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: Config.fontFamily,
                              fontSize: fontSize(context)),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            NewCommentCard(
                                themeColor: Config.darkModeOn
                                    ? Colors.orangeAccent
                                    : Config.getColor(widget.recipe.id),
                                focusNode: _newCommentNode,
                                textController: _commentController,
                                onSubmit: _submitComment,
                                profileImageUrl: Config.loggedIn
                                    ? FirebaseAuth
                                            .instance.currentUser!.photoURL ??
                                        defaultProfileUrl
                                    : defaultProfileUrl),
                            Column(
                              children: widget.comments.keys
                                  .map((id) => CommentCard(
                                        commentId: id,
                                        comment: widget.comments[id]!,
                                        recipeId: widget.recipe.id,
                                        onDelete: () => setState(() {
                                          widget.comments.remove(id);
                                        }),
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
      ),
    );
  }

  Future _submitComment(String result) async {
    if (result.isEmpty || !Config.loggedIn) {
      return;
    }
    var user = FirebaseAuth.instance.currentUser!;
    await CommentDbManager().addNewComment(
        comment: Comment(
            profileUrl: user.photoURL?? defaultProfileUrl,
            userName: user.displayName?? "Пользователь",
            postTime: DateTime.now(),
            text: result,
            uid: user.uid
        ),
        recipeId: widget.recipe.id,
    );
    setState(() {
      _commentController.clear();
    });
    await widget.updateComments();
    if (_disposed) return;
    setState(() {
    });
  }
}
