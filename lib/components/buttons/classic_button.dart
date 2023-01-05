import 'package:flutter/material.dart';

import '../../config.dart';

class ClassicButton extends StatefulWidget {
  const ClassicButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.fontSize = 20,
        this.customColor});

  final VoidCallback onTap;
  final String text;
  final double fontSize;
  final Color? customColor;

  @override
  State<ClassicButton> createState() => _ClassicButtonState();

  static Color get color => Config.darkModeOn ? Colors.grey.shade900
      : Colors.grey.shade200;

  static Color get hoverColor => Config.darkModeOn ? const Color(0xffc77202)
      : Colors.white;    
}

class _ClassicButtonState extends State<ClassicButton> {
  bool _hovered = false;

  Color get color => !_hovered
      ? widget.customColor?? ClassicButton.color
      : ClassicButton.hoverColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (h) => setState(() => _hovered = h),
      borderRadius: Config.borderRadiusLarge,
      hoverColor: ClassicButton.hoverColor,
      focusColor: ClassicButton.hoverColor.withOpacity(.5),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Config.shortAnimationTime,
        decoration: BoxDecoration(
          color: color,
              borderRadius: Config.borderRadiusLarge,
          boxShadow: Config.darkModeOn ? [] : _hovered ?
            [
            BoxShadow(
              color: Colors.orangeAccent,
              spreadRadius: 1
            )
            ] : [
            BoxShadow(
              color: Config.iconColor.withOpacity(0.5),
              spreadRadius: 0.5
            )
          ]
        ),
        padding: const EdgeInsets.all(Config.padding)
            .add(const EdgeInsets.symmetric(horizontal: Config.padding)),
        child: Center(
          child: Text(widget.text,
              style: TextStyle(
                  color: Config.iconColor,
                  fontSize: widget.fontSize,
                  fontFamily: Config.fontFamily
              )
          ),
        ),
      ),
    );
  }
}
