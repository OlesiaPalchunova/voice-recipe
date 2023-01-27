import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/review_views/new_comment_card.dart';
import 'package:voice_recipe/components/buttons/favorites_button.dart';
import 'package:voice_recipe/components/review_views/rate_label.dart';
import 'package:voice_recipe/components/review_views/comment_card.dart';
import 'package:voice_recipe/components/review_views/star_panel.dart';
import 'package:voice_recipe/model/comments_model.dart';
import 'package:voice_recipe/model/db/comment_db_manager.dart';

import '../../config.dart';
import '../../model/recipes_info.dart';
import '../../model/users_info.dart';
import 'package:share_plus/share_plus.dart';

class ReviewsSlide extends StatefulWidget {
  ReviewsSlide({super.key, required this.recipe});

  final Recipe recipe;
  static final FocusNode newCommentNode = FocusNode();
  static final commentController = TextEditingController();

  @override
  State<ReviewsSlide> createState() => _ReviewsSlideState();

  final StreamController<MapEntry<String, Comment>> commentsController =
      StreamController.broadcast();
  final Map<String, Comment> comments = {};

  Future updateComments() async {
    var commentsDb = await CommentDbManager().getComments(recipe.id);
    for (MapEntry<String, Comment> entry in commentsDb.entries) {
      commentsController.add(entry);
      comments[entry.key] = entry.value;
    }
  }
}

class _ReviewsSlideState extends State<ReviewsSlide> {
  var _isEvaluated = false;
  bool _disposed = false;
  StreamSubscription<MapEntry<String, Comment>>? subscription;

  double fontSize(BuildContext context) => Config.isDesktop(context) ? 20 : 18;

  Map<String, Comment> get comments => widget.comments;

  @override
  initState() {
    super.initState();
    _disposed = false;
    int? rate = ratesMap[widget.recipe.id];
    if (rate != null) {
      if (rate > 0) {
        _isEvaluated = true;
      }
    }
    subscription ??= widget.commentsController.stream.listen((event) {
      comments[event.key] = event.value;
      if (_disposed) return;
      setState(() {});
    });
  }

  @override
  dispose() {
    _disposed = true;
    super.dispose();
  }

  double get labelWidth => min(65, Config.recipeSlideWidth(context) / 6);

  String get recipeLink => "https://talkychef.ru/recipe/${widget.recipe.id}";

  @override
  Widget build(BuildContext context) {
    final Color backColor =
        Config.darkModeOn ? Colors.black12 : Colors.white.withOpacity(.8);
    return Container(
      margin: const EdgeInsets.all(Config.margin),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Config.padding),
      color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RateLabel(
                    rate: rates[widget.recipe.id % rates.length],
                    width: labelWidth,
                    shadowOn: false,
                  ),
                  FavoritesButton(
                    recipeId: widget.recipe.id,
                  )
                ],
              ),
              !_isEvaluated
                  ? Container(
                      margin: const EdgeInsets.only(top: Config.padding),
                      padding: const EdgeInsets.all(Config.padding),
                      decoration: BoxDecoration(
                          color: backColor,
                          borderRadius: Config.borderRadiusLarge),
                      child: Column(
                        children: [
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Оставьте отзыв",
                                style: TextStyle(
                                    fontFamily: Config.fontFamily,
                                    fontSize: fontSize(context),
                                    color: Config.iconColor),
                              ),
                            ],
                          ),
                          StarPanel(
                            id: widget.recipe.id,
                            onTap: (star) {
                              ratesMap[widget.recipe.id] = star;
                            },
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              Container(
                margin: const EdgeInsets.only(top: Config.padding),
                decoration: BoxDecoration(
                    color: backColor, borderRadius: Config.borderRadiusLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Config.padding).
                      add(const EdgeInsets.only(top: Config.margin)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Поделиться рецептом",
                                style: TextStyle(
                                    color: Config.darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: Config.fontFamily,
                                    fontSize: fontSize(context)),
                              ),
                              SelectableText(
                                recipeLink,
                                style: TextStyle(
                                    color: Config.getColor(widget.recipe.id),
                                    fontFamily: Config.fontFamily,
                                    fontSize: fontSize(context) - 2),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: Config.borderRadius,
                              color: Config.backgroundLightedColor,
                            ),
                            height: 40,
                            width: 40,
                            child: IconButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: recipeLink));
                                  Future.microtask(() => Config.showAlertDialog(
                                      "Ссылка успешно скопирована", context));
                                },
                                icon: Icon(
                                  Icons.link_outlined,
                                  color: Config.iconColor,
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: Config.paddingAll,
                      width: Config.recipeSlideWidth(context) * .4,
                      child: ClassicButton(
                        onTap: () {
                          Share.share(recipeLink, subject: widget.recipe.name);
                        },
                        text: "Отправить",
                        fontSize: fontSize(context) - 2,
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
                            color:
                                Config.darkModeOn ? Colors.white : Colors.black,
                            fontFamily: Config.fontFamily,
                            fontSize: fontSize(context)),
                      ),
                    ),
                    Column(
                      children: [
                        NewCommentCard(
                            focusNode: ReviewsSlide.newCommentNode,
                            textController: ReviewsSlide.commentController,
                            onSubmit: _submitComment,
                            onCancel: () {},
                            profileImageUrl: Config.loggedIn
                                ? FirebaseAuth.instance.currentUser!.photoURL ??
                                    defaultProfileUrl
                                : defaultProfileUrl),
                        Column(
                          children: comments.keys
                              .map((id) => CommentCard(
                                    onUpdate: _updateComment,
                                    commentId: id,
                                    comment: comments[id]!,
                                    recipeId: widget.recipe.id,
                                    onDelete: () => setState(() {
                                      comments.remove(id);
                                    }),
                                  ))
                              .toList(),
                        ),
                      ],
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

  Future _updateComment(String newText, String commentId) async {
    if (newText.isEmpty || !Config.loggedIn) {
      return;
    }
    await CommentDbManager().updateComment(
        newText: newText, recipeId: widget.recipe.id, commentId: commentId);
    await widget.updateComments();
    if (_disposed) return;
    setState(() {});
  }

  Future _submitComment(String result) async {
    if (result.isEmpty || !Config.loggedIn) {
      return;
    }
    var user = FirebaseAuth.instance.currentUser!;
    await CommentDbManager().addNewComment(
      comment: Comment(
          profileUrl: user.photoURL ?? defaultProfileUrl,
          userName: user.displayName ?? "Пользователь",
          postTime: DateTime.now(),
          text: result,
          uid: user.uid),
      recipeId: widget.recipe.id,
    );
    if (!_disposed) {
      setState(() {
        ReviewsSlide.commentController.clear();
      });
    }
    await widget.updateComments();
    if (_disposed) return;
    setState(() {});
  }
}
