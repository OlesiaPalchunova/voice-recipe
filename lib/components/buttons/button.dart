import 'package:flutter/material.dart';

import '../../config.dart';

class ClassicButton extends StatefulWidget {
  const ClassicButton(
      {super.key, required this.onTap, required this.text, this.width = 300,
      this.fontSize = 20, this.color = const Color(0xff050505),
      this.hoverColor = const Color(0xff101010), this.shadowOn = true,
      this.textColor = Colors.white});

  final VoidCallback onTap;
  final String text;
  final double width;
  final double fontSize;
  final Color color;
  final Color hoverColor;
  final Color textColor;
  final bool shadowOn;

  @override
  State<ClassicButton> createState() => _ClassicButtonState();
}

class _ClassicButtonState extends State<ClassicButton> {
  bool _hovered = false;
  bool _pressed = false;

  Color get backColor => _hovered | _pressed ?
  widget.hoverColor :
  widget.color;

  List<BoxShadow> get shadow => !_hovered & !_pressed | !widget.shadowOn
      ? []
      : const [BoxShadow(color: Colors.orangeAccent, blurRadius: 12)];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovered) => setState(() {
        _hovered = hovered;
      }),
      onTap: () async {
        setState(() {
          _pressed = true;
        });
        await Future.delayed(Config.shortAnimationTime).whenComplete(() {
          setState(() {
            _pressed = false;
          });
        });
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: Config.shortAnimationTime,
        decoration: BoxDecoration(
            color: backColor,
            borderRadius: Config.borderRadiusLarge,
            boxShadow: shadow),
        width: widget.width,
        padding: const EdgeInsets.all(Config.padding),
        child: Center(
          child: Text(widget.text,
              style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                  fontFamily: Config.fontFamily)),
        ),
      ),
    );
  }
}
