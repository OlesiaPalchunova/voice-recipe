import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
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

class SayButtonState extends State<SayButton> with TickerProviderStateMixin {
  var _isSaying = false;
  static SayButtonState? _state;
  late AnimationController _controller;

  static SayButtonState? current() {
    return _state;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Config.animationTime,
        vsync: this
    );
    _state = this;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderButtonsPanel.buildButton(_buildSayIcon(),
        !_isSaying ? Config.iconBackColor() : Config.disabledIconBackColor());
  }

  void say() {
    if (_isSaying) return;
    setState(() {
      _isSaying = true;
    });
    widget.onSay();
  }

  void stopSaying() {
    if (!_isSaying) return;
    setState(() {
      _isSaying = false;
    });
    widget.onStopSaying();
  }

  bool isSaying() {
    return _isSaying;
  }

  IconButton _buildSayIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSaying = !_isSaying;
          });
          if (_isSaying) {
            _controller.forward();
            widget.onSay();
          } else {
            _controller.reverse();
            widget.onStopSaying();
          }
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _controller,
          color: Config.iconColor(),
        )
    );
  }
}
