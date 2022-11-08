import 'package:flutter/material.dart';

import 'package:voice_recipe/components/header_buttons_panel.dart';
import 'package:voice_recipe/config.dart';

class SayButton extends StatefulWidget {
  const SayButton({super.key,
    required this.onSay,
    required this.onStopSaying,
    required this.iconSize});

  final void Function() onSay;
  final void Function() onStopSaying;
  final double iconSize;

  @override
  State<SayButton> createState() => SayButtonState();
}

class SayButtonState extends State<SayButton> {
  static var _isSaying = false;

  static bool isSaying() {
    return _isSaying;
  }

  @override
  Widget build(BuildContext context) {
    return HeaderButtonsPanel.buildButton(_buildSayIcon(),
        !_isSaying ? Config.iconBackColor : Config.iconDisabledBackColor);
  }

  IconButton _buildSayIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSaying = !_isSaying;
          });
          if (_isSaying) {
            widget.onSay();
          } else {
            widget.onStopSaying();
          }
        },
        icon: _isSaying
            ? Icon(
          Icons.pause,
          color: Config.iconColor,
          size: widget.iconSize,
        )
            : Icon(
          Icons.play_arrow,
          color: Config.iconColor,
          size: widget.iconSize,
        )
    );
  }
}
