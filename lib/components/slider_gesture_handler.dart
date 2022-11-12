import 'package:flutter/cupertino.dart';

class SliderGestureHandler extends StatelessWidget {
  SliderGestureHandler({super.key, required this.onLeft,
  required this.onRight, required this.child});

  final void Function() onRight;
  final void Function() onLeft;
  final Widget child;
  static const minSlideChangeDelayMillis = 400;
  var lastSwipeTime = DateTime.now().subtract(const Duration(seconds: 1));
  var lastTapDownTime = DateTime.now().subtract(const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails d) => lastTapDownTime = DateTime.now(),
      onPanUpdate: _swipeHandler,
      onTapUp: (TapUpDetails details) => _tapHandler(details, context),
      child: child,
    );
  }

  void _tapHandler(TapUpDetails details, BuildContext context) {
    if (DateTime.now().difference(lastTapDownTime).inMilliseconds > 1000) {
      return;
    }
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
    const int sensitivity = 2;
    var cur = DateTime.now();
    // debugPrint('${cur.difference(lastSwipeTime).inMilliseconds}/$minSlideChangeDelayMillis');
    if (cur.difference(lastSwipeTime).inMilliseconds <=
        minSlideChangeDelayMillis) {
      return;
    }
    if (details.delta.dy.abs() > details.delta.dx.abs()) {
      return;
    }
    if (details.delta.dx > sensitivity) {
      lastSwipeTime = cur;
      onLeft();
    }
    if (details.delta.dx < -sensitivity) {
      lastSwipeTime = cur;
      onRight();
    }
  }
}