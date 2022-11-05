import 'package:flutter/cupertino.dart';

class SliderGestureHandler extends StatelessWidget {
  SliderGestureHandler({super.key, required this.onLeft,
  required this.onRight, required this.child});

  final void Function() onRight;
  final void Function() onLeft;
  final Widget child;
  static const minSlideChangeDelayMillis = 100;
  final lastSwipeTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _swipeHandler,
      onTapDown: (TapDownDetails details) => _tapHandler(details, context),
      child: child,
    );
  }

  void _tapHandler(TapDownDetails details, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    final x = localOffset.dx;
    if (x < box.size.width / 2) {
      onLeft();
    } else {
      onRight();
    }
  }

  void _swipeHandler(DragUpdateDetails details) {
    int sensitivity = 0;
    var cur = DateTime.now();
    if (cur.difference(lastSwipeTime).inMilliseconds <=
        minSlideChangeDelayMillis) {
      return;
    }
    if (details.delta.dx != 0) {
      lastSwipeTime.add(cur.difference(lastSwipeTime));
    }
    if (details.delta.dx > sensitivity) {
      onLeft();
    }
    if (details.delta.dx < sensitivity) {
      onRight();
    }
  }
}