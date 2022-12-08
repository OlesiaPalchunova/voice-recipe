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

class ReviewView extends StatefulWidget {
  const ReviewView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  var _isEvaluated = false;
  final _commentController = TextEditingController();
  final FocusNode _newCommentNode = FocusNode();
  late List<Comment> comments = [];
  bool _disposed = false;

  double fontSize(BuildContext context) => Config.isDesktop(context)
      ? 20 : 18;

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

  Future updateComments() async {
    comments = await CommentDbManager().getComments(widget.recipe.id);
    if (_disposed) return;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    updateComments();
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
                      color: backColor,
                      borderRadius: Config.borderRadiusLarge
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
                      color: backColor,
                      borderRadius: Config.borderRadiusLarge
                  ),
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
                              fontSize: fontSize(context)
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            NewCommentCard(
                                focusNode: _newCommentNode,
                                textController: _commentController,
                                onSubmit: _submitComment,
                                profileImageUrl: Config.loggedIn
                                    ? FirebaseAuth.instance.currentUser!.photoURL
                                    ?? defaultProfileUrl
                                    : defaultProfileUrl
                            ),
                            Column(
                              children: comments
                                  .map((e) =>
                                  CommentCard(
                                    review: e,
                                    recipeId: widget.recipe.id,
                                    onDelete: () => setState(() {
                                      comments.remove(e);
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
            postTime: DateTime.now(),
            text: result,
            userName: user.displayName ??
                "Пользователь",
            profilePhotoURL: user.photoURL ??
                defaultProfileUrl,
            uid: user.uid
        ),
        recipeId: widget.recipe.id,
        commentId: 1
    );
    updateComments();
    setState(() {
      _commentController.clear();
    });
  }
}
