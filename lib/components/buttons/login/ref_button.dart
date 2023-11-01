import 'package:flutter/material.dart';

import 'package:voice_recipe/config/config.dart';

class RefButton extends StatefulWidget {
  const RefButton({key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  State<RefButton> createState() => _RefButtonState();
}

class _RefButtonState extends State<RefButton> {
  bool hovered = false;
  bool pressed = false;

  TextDecoration get decoration => hovered | pressed ?
      TextDecoration.underline : TextDecoration.none;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (h) => setState(() {
        hovered = h;
      }),
      onTap: () async {
        setState(() {
          pressed = true;
        });
        await Future.delayed(Config.shortAnimationTime).whenComplete(() => setState(() {
          pressed = false;
        }));
        widget.onTap();
      },
      borderRadius: Config.borderRadiusLarge,
      child: Container(
        padding: const EdgeInsets.all(Config.padding),
        child: Text(
          widget.text,
          style: TextStyle(
              color: Config.iconColor.withOpacity(.8),
              fontSize: Config.fontSizeMedium(context),
              fontFamily: Config.fontFamily,
              decoration: decoration
          ),
        ),
      )
    );
  }
}
