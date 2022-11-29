import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../config.dart';

class StarPanel extends StatefulWidget {
  const StarPanel({super.key, required this.id, required this.onTap});

  final int id;
  final Function(int) onTap;

  @override
  State<StarPanel> createState() => StarPanelState();
}

class StarPanelState extends State<StarPanel> {
  static const _initialMinIdx = - 1;
  late int _minIdx;
  late var _currentStarIdx = _minIdx;
  static const starsCount = 5;
  static StarPanelState? current;
  static final starsTable = HashMap<int, int>();

  @override
  void initState() {
    current = this;
    _minIdx = starsTable[widget.id] ?? -1;
    super.initState();
  }

  @override
  void dispose() {
    starsTable[widget.id] = _minIdx;
    super.dispose();
  }

  void clear() {
    setState(() {
      _minIdx = - 1;
      _currentStarIdx = _minIdx;
    });
  }

  Color starColor(int index) {
    if (_minIdx == _initialMinIdx) {
      return index <= _currentStarIdx
          ? Config.darkModeOn ? Colors.white : Colors.yellow.shade400
          : Config.darkModeOn ? Colors.grey : Colors.grey.shade200;
    }
    return index <= _currentStarIdx
        ? Colors.yellow.shade600
        : Config.darkModeOn ? Colors.grey : Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final width = Config.loginPageWidth(context);
    final double starSize = width / 2 / starsCount;
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: List.generate(starsCount,
            (index) => InkWell(
              onHover: (hovered) {
                if (_minIdx != _initialMinIdx) return;
                setState(() {
                  if (hovered) {
                    _currentStarIdx = index;
                  } else {
                    _currentStarIdx = _minIdx;
                  }
                });
              },
              onTap: () {
                setState(() {
                  widget.onTap(index);
                  _minIdx = index;
                  _currentStarIdx = index;
                });
              },
              child: AnimatedContainer(
                  duration: Config.animationTime,
                  height: starSize,
                  width: starSize,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.star,
                    color: starColor(index),
                    size: starSize,
                  ),
              ),
            )
        ),
      ),
    );
  }
}
