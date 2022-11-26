import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class Button extends StatefulWidget {
  const Button(
      {super.key, required this.onTap, required this.text, this.width = 300});

  final VoidCallback onTap;
  final String text;
  final double width;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _hovered = false;
  bool _pressed = false;

  Color get backColor => _hovered | _pressed ?
  const Color(0xff101010) :
  const Color(0xff050505);

  List<BoxShadow> get shadow => !_hovered & !_pressed
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
            borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
            boxShadow: shadow),
        width: widget.width,
        child: Center(
          child: Text(widget.text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: Config.fontFamily)),
        ),
      ),
    );
  }
}
