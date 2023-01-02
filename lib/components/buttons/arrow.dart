import 'package:flutter/material.dart';

import '../../config.dart';

enum Direction { left, right }

class ArrowButton extends StatefulWidget {
  const ArrowButton(
      {super.key,
      required this.direction,
      required this.onTap,});

  final Direction direction;
  final VoidCallback onTap;

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  bool hovered = false;

  String get imageName =>
      widget.direction == Direction.right ? "right" : "left";

  String get postfix => "";

  Alignment get align => widget.direction == Direction.right
      ? Alignment.centerRight
      : Alignment.centerLeft;

  double get offset => hovered
      ? Config.pageWidth(context) * .23
      : Config.pageWidth(context) * .25;

  EdgeInsetsGeometry get insets => widget.direction == Direction.right
      ? EdgeInsets.only(right: offset)
      : EdgeInsets.only(left: offset);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: insets,
      alignment: align,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.onTap();
          });
        },
        onHover: (h) {
          setState(() => hovered = h);
        },
        hoverColor: Colors.grey,
        child: Container(
          width: hovered
              ? Config.pageWidth(context) / 6
              : Config.pageWidth(context) / 7,
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                AssetImage("assets/images/decorations/$imageName$postfix.png"),
          )),
        ),
      ),
    );
  }
}
