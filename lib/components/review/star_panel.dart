import 'package:flutter/material.dart';

import '../../config.dart';

class StarPanel extends StatefulWidget {
  const StarPanel({super.key, required this.onTap, this.activeStarsCount = 0});

  final Function(int) onTap;
  final int activeStarsCount;

  @override
  State<StarPanel> createState() => _StarPanelState();
}

class _StarPanelState extends State<StarPanel> {
  late var _minIdx = widget.activeStarsCount - 1;
  late var _currentStarIdx = _minIdx;
  static const starsCount = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: List.generate(starsCount,
            (index) => InkWell(
              onHover: (hovered) {
                if (_minIdx >= 0) return;
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
                  alignment: Alignment.center,
                  child: Icon(
                    index <= _currentStarIdx
                        ? Icons.star
                        : Icons.star_border,
                    color: index <= _currentStarIdx ? Colors.yellow : Config.iconColor,
                    size: Config.pageWidth(context) / ((starsCount + 1) * 2),
                    weight: 0.01,
                    opticalSize: 0.01,
                  ),
              ),
            )
        ),
      ),
    );
  }
}
