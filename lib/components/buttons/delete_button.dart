import 'package:flutter/material.dart';

import '../../config.dart';
import 'classic_button.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.onPressed,
  this.toolTip, this.margin});

  double get buttonSize => 40;
  final VoidCallback onPressed;
  final String? toolTip;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
          color: ClassicButton.color,
          borderRadius: Config.borderRadius
      ),
      margin: margin?? Config.paddingAll,
      alignment: Alignment.center,
      child: IconButton(
        tooltip: toolTip,
        icon: Icon(
          Icons.delete_outline_outlined,
          color: Config.iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }

}