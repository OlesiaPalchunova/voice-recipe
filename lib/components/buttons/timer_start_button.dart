import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config.dart';

class TimerStartButton extends StatefulWidget {
  const TimerStartButton({super.key,
    required this.onStart,
    required this.onStop,
    required this.iconSize});

  final void Function() onStart;
  final void Function() onStop;
  final double iconSize;

  @override
  State<TimerStartButton> createState() => TimerStartButtonState();
}

class TimerStartButtonState extends State<TimerStartButton> with TickerProviderStateMixin {
  var _isRunning = false;
  late AnimationController _controller;
  static TimerStartButtonState? current;

  @override
  void initState() {
    super.initState();
    current = this;
    _controller = AnimationController(
        duration: Config.animationTime,
        vsync: this
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void update(bool running) {
    setState(() {
      debugPrint("\n\n\n$running");
      _isRunning = running;
      if (_isRunning) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isRunning = !_isRunning;
          });
          if (_isRunning) {
            _controller.forward();
            widget.onStart();
          } else {
            _controller.reverse();
            widget.onStop();
          }
        },
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _controller,
          size: widget.iconSize,
          color: Config.iconColor(),
        ),
        ),
    );
  }
}
