import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config/config.dart';

class SayButton extends StatefulWidget {
  const SayButton(
      {key,
      required this.sayNotyfyer,
      required this.onSay,
      required this.onStopSaying,
      required this.iconSize});

  final ValueNotifier<bool> sayNotyfyer;
  final void Function() onSay;
  final void Function() onStopSaying;
  final double iconSize;

  @override
  State<SayButton> createState() => _SayButtonState();
}

class _SayButtonState extends State<SayButton> with TickerProviderStateMixin {
  late AnimationController _controller;

  late bool isSaying = widget.sayNotyfyer.value;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Config.animationTime, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.sayNotyfyer,
        builder: (context, bool newIsSaying, child) {
          if (newIsSaying != isSaying) {
            isSaying = newIsSaying;
            if (isSaying) {
              widget.onSay();
            } else {
              widget.onStopSaying();
            }
          }
          return HeaderButtonsPanel.buildButton(_buildSayIcon(),
              !isSaying ? Config.iconBackColor : Config.disabledIconBackColor);
        });
  }

  IconButton _buildSayIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            isSaying = !isSaying;
          });
          if (isSaying) {
            _controller.forward();
            widget.onSay();
          } else {
            _controller.reverse();
            widget.onStopSaying();
          }
        },
        tooltip: "Произнести",
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _controller,
          color: Config.iconColor,
        ));
  }
}
