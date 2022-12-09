import 'package:flutter/material.dart';

import '../../config.dart';
import '../buttons/button.dart';
import 'comment_card.dart';

class NewCommentCard extends StatefulWidget {
  const NewCommentCard({super.key,
    required this.focusNode,
    required this.textController,
    required this.onSubmit,
    required this.profileImageUrl,
    required this.themeColor
  });

  final FocusNode focusNode;
  final Color themeColor;
  final TextEditingController textController;
  final void Function(String) onSubmit;
  final String profileImageUrl;

  @override
  State<NewCommentCard> createState() => _NewCommentCardState();
}

class _NewCommentCardState extends State<NewCommentCard> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    double width = Config.recipeSlideWidth(context);
    List<Widget> columnChildren = [
      TextField(
          focusNode: widget.focusNode,
          autofocus: false,
          controller: widget.textController,
          style: TextStyle(
              color: Config.iconColor,
              fontFamily: Config.fontFamily
          ),
          onTap: () {
            if (Config.loggedIn) {
              setState(() {
                focused = true;
              });
              return;
            }
            widget.focusNode.unfocus();
            Config.showLoginInviteDialog(context);
          },
          onSubmitted: (s) => onSubmit(),
          decoration: InputDecoration(
              hintText: 'Оставьте свой комментарий',
              hintStyle: TextStyle(
                  color: Config.iconColor.withOpacity(0.5),
                  fontFamily: Config.fontFamily,
                  fontSize: CommentCard.descFontSize(context)
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Config.iconColor.withOpacity(0.5)
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.themeColor
                  )
              ),
          )
      ),
    ];
    if (focused) {
      columnChildren.addAll([
        const SizedBox(height: Config.padding,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Row(
                children: [
                  ClassicButton(
                    text: "Отмена",
                    onTap: onCancel,
                    fontSize: fontSize(context),
                  ),
                  const SizedBox(width: Config.padding,),
                  ClassicButton(
                    text: "Оставить комментарий",
                    onTap: onSubmit,
                    fontSize: fontSize(context),
                  ),
                ]
            )
          ],
        )
      ]);
    }
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      margin: const EdgeInsets.symmetric(vertical: Config.margin),
      decoration: const BoxDecoration(
          borderRadius: Config.borderRadius),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: Config.padding * 5),
          child: Column(
            children: columnChildren,
          ),
        ),
        CircleAvatar(
          radius: Config.padding * 2,
          backgroundColor: Config.pressed,
          backgroundImage: NetworkImage(widget.profileImageUrl),
        ),
      ]),
    );
  }

  Color get buttonColor => Config.darkModeOn ? Colors.grey.shade900
  : Colors.grey.shade800;

  Color get buttonHoverColor => Config.darkModeOn ? Colors.blueGrey.shade900
      : Colors.blueGrey.shade800;

  double fontSize(BuildContext context) {
    if (Config.isDesktop(context)) {
      return 16;
    }
    return 13;
  }

  void onCancel() {
    setState(() {
      widget.textController.clear();
      focused = false;
    });
  }

  void onSubmit() {
    String text = widget.textController.text;
    if (text.isEmpty) {
      Config.showAlertDialog("Комментарий не может быть пустым", context);
      return;
    }
    setState(() {
      focused = false;
    });
    widget.onSubmit(text);
  }
}
