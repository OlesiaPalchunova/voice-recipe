import 'package:flutter/material.dart';

import '../../../config/config.dart';

class RefButton extends StatefulWidget {
  const RefButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  State<RefButton> createState() => _RefButtonState();
}

class _RefButtonState extends State<RefButton> {
  bool _hovered = false;
  bool _pressed = false;

  TextDecoration get decoration => _hovered | _pressed ?
      TextDecoration.underline : TextDecoration.none;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (h) => setState(() {
        _hovered = h;
      }),
      onTap: () async {
        setState(() {
          _pressed = true;
        });
        await Future.delayed(Config.shortAnimationTime).whenComplete(() => setState(() {
          _pressed = false;
        }));
        widget.onTap();
      },
      borderRadius: Config.borderRadiusLarge,
      child: Container(
        padding: const EdgeInsets.all(Config.padding),
        child: Text(
          widget.text,
          style: TextStyle(
              color: Config.iconColor.withOpacity(0.8),
              fontSize: 18,
              fontFamily: Config.fontFamily,
              decoration: decoration
          ),
        ),
      )
    );
  }
}
