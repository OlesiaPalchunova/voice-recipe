import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';
import 'classic_button.dart';

class DeleteButton extends StatefulWidget {
  const DeleteButton({key, required this.onPressed,
  this.toolTip, this.margin});

  final VoidCallback onPressed;
  final String? toolTip;
  final EdgeInsetsGeometry? margin;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  double get buttonSize => 40;
  bool hovered = false;

  Color get color => !hovered ? ClassicButton.color.darken(1) : ClassicButton.hoverColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.toolTip?? "",
      child: InkWell(
        onHover: (h) => (setState(() => hovered = h)),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Config.shortAnimationTime,
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
              color: color,
              borderRadius: Config.borderRadius,
              border: Border.all(
                color: Config.iconColor,
                width: .3
              )
          ),
          margin: widget.margin?? Config.paddingAll,
          alignment: Alignment.center,
          child: Icon(
              Icons.delete_outline_outlined,
              color: Config.iconColor,
            ),
        ),
      ),
    );
  }
}