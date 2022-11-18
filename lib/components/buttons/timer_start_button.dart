import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config.dart';

class TimerStartButton extends StatefulWidget {
  const TimerStartButton(
      {super.key,
      required this.id,
      required this.onStart,
      required this.onStop,
      required this.iconSize});

  final int id;
  final void Function() onStart;
  final void Function() onStop;
  final double iconSize;

  @override
  State<TimerStartButton> createState() => TimerStartButtonState();
}

class TimerStartButtonState extends State<TimerStartButton>
    with TickerProviderStateMixin {
  var _isRunning = false;
  late AnimationController _controller;
  static TimerStartButtonState? current;
  late AnimatedIconData _icon;
  late bool _reversed;
  TimerStartButtonState? _prevState;
  static final Map<int, TimerStartButtonState?> _statesTable = {};

  @override
  void initState() {
    super.initState();
    current = this;
    _controller = AnimationController(duration: Config.animationTime, vsync: this);
    if (_statesTable.containsKey(widget.id)) {
      _prevState = _statesTable[widget.id];
    }
    if (_prevState != null) {
      if (_prevState!._isRunning) {
        _icon = AnimatedIcons.pause_play;
        _reversed = true;
        return;
      }
    }
    _icon = AnimatedIcons.play_pause;
    _reversed = false;
  }

  @override
  void dispose() {
    _statesTable[widget.id] = this;
    _controller.dispose();
    super.dispose();
  }

  void update(bool running) {
    if (running == _isRunning) return;
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
            _reversed ? _controller.reverse() : _controller.forward();
            widget.onStart();
          } else {
            _reversed ? _controller.forward() : _controller.reverse();
            widget.onStop();
          }
        },
        child: AnimatedIcon(
          icon: _icon,
          progress: _controller,
          size: widget.iconSize,
          color: Config.iconColor,
        ),
      ),
    );
  }
}
