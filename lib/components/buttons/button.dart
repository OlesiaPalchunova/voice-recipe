import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class ClassicButton extends StatefulWidget {
  const ClassicButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.fontSize = 20,
      });

  final VoidCallback onTap;
  final String text;
  final double fontSize;

  @override
  State<ClassicButton> createState() => _ClassicButtonState();

  static Color get buttonColor => Config.darkModeOn ? Colors.grey.shade900
      : Colors.grey.shade200;

  static Color get buttonHoverColor => Config.darkModeOn ? const Color(0xffc77202)
      : Colors.blueGrey.shade100;
}

class _ClassicButtonState extends State<ClassicButton> {
  bool _hovered = false;
  bool _pressed = false;

  void _onTap() {
    widget.onTap();
    setState(() => _pressed = !_pressed);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (h) => setState(() => _hovered = h),
      borderRadius: Config.borderRadiusLarge,
      hoverColor: ClassicButton.buttonHoverColor,
      focusColor: ClassicButton.buttonHoverColor,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Config.shortAnimationTime,
        decoration: BoxDecoration(
          color: !_hovered & !_pressed ? ClassicButton.buttonColor : ClassicButton.buttonHoverColor,
              borderRadius: Config.borderRadiusLarge,
          border: Border.all(
              color: Colors.black87,
              width: 0.1
          ),
        ),
        padding: const EdgeInsets.all(Config.padding)
            .add(const EdgeInsets.symmetric(horizontal: Config.padding)),
        child: Center(
          child: Text(widget.text,
              style: TextStyle(
                  color: Config.iconColor,
                  fontSize: widget.fontSize,
                  fontFamily: Config.fontFamily)),
        ),
      ),
    );
  }
}
