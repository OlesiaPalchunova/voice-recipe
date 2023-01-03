import 'package:flutter/material.dart';

import '../../config.dart';

enum Direction { left, right }

class ArrowButton extends StatefulWidget {
  const ArrowButton({
    super.key,
    required this.direction,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
        margin: !hovered ? const EdgeInsets.all(Config.padding) : null,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/decorations/$imageName$postfix.png"),
        )),
      ),
    );
  }
}
