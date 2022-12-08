import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SliderGestureHandler extends StatelessWidget {

  SliderGestureHandler({super.key, required this.onLeft,
  required this.onRight, required this.child, this.handleTaps = true,
  this.ignoreVerticalSwipes = true});

  final _focusNode = FocusNode();
  final void Function() onRight;
  final void Function() onLeft;
  final Widget child;
  final bool handleTaps;
  final bool ignoreVerticalSwipes;
  static const minSwipeTimeMillis = 400;
  static const minKeyboardSwipeTimeMillis = 200;
  var lastSwipeTime = DateTime.now();
  var lastTapDownTime = DateTime.now().subtract(const Duration(seconds: 1));

  void _handleKeyEvent(RawKeyEvent event) {
    var cur = DateTime.now();
    if (cur.difference(lastSwipeTime).inMilliseconds <=
        minKeyboardSwipeTimeMillis) {
      return;
    }
    if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        //|| event.physicalKey == PhysicalKeyboardKey.keyD) {
      onRight();
      lastSwipeTime = cur;
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
        // || event.physicalKey == PhysicalKeyboardKey.keyA) {
      onLeft();
      lastSwipeTime = cur;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _handleKeyEvent,
      child: GestureDetector(
        onTapDown: (TapDownDetails d) => lastTapDownTime = DateTime.now(),
        onPanUpdate: _swipeHandler,
        onTapUp: handleTaps ? (TapUpDetails details) => _tapHandler(details, context)
            : (TapUpDetails details) {},
        child: child,
      ),
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
        minSwipeTimeMillis) {
      return;
    }
    if (ignoreVerticalSwipes && details.delta.dy.abs() > details.delta.dx.abs()) {
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