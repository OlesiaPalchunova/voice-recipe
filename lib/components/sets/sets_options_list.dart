import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../model/sets_info.dart';

class SetsOptionsList extends StatefulWidget {
  const SetsOptionsList({super.key, required this.set});

  final RecipesSet set;

  @override
  State<SetsOptionsList> createState() => _SetsOptionsListState();
}

class _SetsOptionsListState extends State<SetsOptionsList> with SingleTickerProviderStateMixin {
  late final _menuTitles = optionsResolve[widget.set.id - 1];
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 300);
  late final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();
    _createAnimationIntervals();
    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
    final buttonStartTime = Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Config.padding * 1.5,
            horizontal: Config.padding * 2),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Config.iconColor(),
                  size: 9,
                ),
                SizedBox(
                  width: Config.pageWidth(context) / 50
                ),
                Text(
                  _menuTitles[i].name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: Config.fontFamily,
                      fontWeight: FontWeight.w500,
                      color: Config.iconColor()
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: listItems,
    );
  }
}
