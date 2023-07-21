import 'package:flutter/material.dart';
import 'package:voice_recipe/model/comments_model.dart';
import 'package:voice_recipe/services/db/comment_db_manager.dart';
import 'package:voice_recipe/services/service_io.dart';

import '../../config/config.dart';
import '../../model/users_info.dart';
import '../../services/auth/Token.dart';
import 'new_comment_card.dart';

class CommentCard extends StatefulWidget {
  const CommentCard(
      {super.key,
      required this.commentId,
      required this.comment,
      required this.recipeId,
      required this.onDelete,
      required this.onUpdate});

  final String commentId;
  final Comment comment;
  final int recipeId;
  final VoidCallback onDelete;
  final void Function(String, String) onUpdate;
  static final editNode = FocusNode();

  static double nameFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 14 : 12;

  static double descFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 16 : 14;

  static double sinceFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 14 : 12;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  static bool editMode = false;
  static final editController = TextEditingController();

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
          padding: const EdgeInsets.only(left: Config.padding * 5).
          add(const EdgeInsets.only(right: Config.padding * 2)),
          // .add(const EdgeInsets.symmetric(vertical: Config.padding)),
          child: Column(
            children: [
              nickname.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: SelectableText(
                            nickname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Config.iconColor,
                                fontFamily: Config.fontFamily,
                                fontSize: CommentCard.nameFontSize(context)),
                          ),
                        ),
                        const SizedBox(
                          width: Config.padding,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: SelectableText(
                            since,
                            style: TextStyle(
                                color: Config.iconColor.withOpacity(0.7),
                                fontFamily: Config.fontFamily,
                                fontSize: CommentCard.sinceFontSize(context)),
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
          padding: const EdgeInsets.only(top: Config.padding),
          alignment: Alignment.bottomRight,
          child: PopupMenuButton<int>(
            padding: const EdgeInsets.all(0),
            position: PopupMenuPosition.under,
            color: Config.pressed,
            tooltip: '',
            itemBuilder: (context) => getCommentOptions(context),
            icon: Icon(
              Icons.more_vert,
              color: Config.iconColor,
            ),
          ),
        )
      ]),
    );
  }

  List<PopupMenuEntry<int>> getCommentOptions(BuildContext context) {
    // if (ServiceIO.loggedIn) {
    // String uid = ServiceIO.user!.uid;
    String uid = Token.getUid();
      if (widget.comment.uid == uid) {
        return <PopupMenuEntry<int>>[
          PopupMenuItem(
            value: 1,
            onTap: editComment,
            child: getOption("Редактировать"),
          ),
          PopupMenuItem(
            value: 2,
            onTap: deleteComment,
            child: getOption("Удалить"),
          ),
        ];
      }
    // }
    return <PopupMenuEntry<int>>[
      PopupMenuItem(
        value: 1,
        child: getOption("Пожаловаться"),
        onTap: () =>
            ServiceIO.showAlertDialog("Ваша жалоба будет рассмотрена", context),
      ),
    ];
  }

  void editComment() {
    setState(() {
      editMode = true;
      editController.text = widget.comment.text;
      CommentCard.editNode.requestFocus();
    });
  }

  Future deleteComment() async {
    // await CommentDbManager().deleteComment(widget.recipeId, widget.commentId);
    await CommentDbManager().deleteComment(widget.commentId);
    widget.onDelete();
  }

  Widget getOption(String name) {
    return Text(
      name,
      style: TextStyle(
          fontFamily: Config.fontFamily, fontSize: 16, color: Config.iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("bbbbbbbbbbbb");
    print(editMode);
    if (editMode) {
      print("mmmmmmmmmmmmmmm");
      return NewCommentCard(
        initialFocused: true,
        focusNode: CommentCard.editNode,
        textController: editController,
        profileImageUrl: "ServiceIO.profileImageUrl",
        onSubmit: (text) {
          if (text.trim() != widget.comment.text.trim()) {
            print("xxxxxxxxxxxxx");
            widget.onUpdate(text, widget.commentId);
          }
          setState(() {
            editMode = false;
          });
        },
        onCancel: () => setState(() => editMode = false),
      );
    }
    return buildCommentFrame(
      context: context,
      nickname: widget.comment.userName,
      since: since(widget.comment.postTime),
      profileImageUrl: widget.comment.profileUrl,
      body: Container(
        alignment: Alignment.topLeft,
        child: SelectableText(
          widget.comment.text,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Config.iconColor.withOpacity(0.9),
              fontFamily: Config.fontFamily,
              fontSize: CommentCard.descFontSize(context)),
        ),
      ),
    );
  }
}
