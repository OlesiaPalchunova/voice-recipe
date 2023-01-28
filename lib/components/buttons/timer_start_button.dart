import 'package:flutter/material.dart';

import 'package:voice_recipe/config/config.dart';

class TimerStartButton extends StatefulWidget {
  const TimerStartButton(
      {super.key,
      required this.id,
      required this.onStart,
      required this.onStop,
      required this.iconSize,
      required this.isRunning});

  final int id;
  final ValueNotifier<bool> isRunning;
  final void Function() onStart;
  final void Function() onStop;
  final double iconSize;

  @override
  State<TimerStartButton> createState() => _TimerStartButtonState();
}

class _TimerStartButtonState extends State<TimerStartButton>
    with TickerProviderStateMixin {
  var isRunning = false;
  late AnimationController _controller;
  late AnimatedIconData _icon;
  late bool _reversed;
  _TimerStartButtonState? _prevState;
  static final Map<int, _TimerStartButtonState?> _statesTable = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Config.animationTime, vsync: this);
    if (_statesTable.containsKey(widget.id)) {
      _prevState = _statesTable[widget.id];
    }
    if (_prevState != null) {
      if (_prevState!.isRunning) {
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

  void handleTimerStatusUpdate() {
    if (isRunning) {
      _reversed ? _controller.reverse() : _controller.forward();
      widget.onStart();
    } else {
      _reversed ? _controller.forward() : _controller.reverse();
      widget.onStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.isRunning,
        builder: (context, newIsRunning, child) {
          if (newIsRunning != isRunning) {
            isRunning = newIsRunning;
            handleTimerStatusUpdate();
          }
          return Container(
            padding: const EdgeInsets.all(Config.padding),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isRunning = !isRunning;
                  handleTimerStatusUpdate();
                });
              },
              child: AnimatedIcon(
                icon: _icon,
                progress: _controller,
                size: widget.iconSize,
                color: Config.iconColor,
              ),
            ),
          );
        });
  }
}
