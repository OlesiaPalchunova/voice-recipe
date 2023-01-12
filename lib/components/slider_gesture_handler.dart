import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SliderGestureHandler extends StatefulWidget {
  const SliderGestureHandler(
      {super.key,
      required this.onLeft,
      required this.onRight,
      required this.child,
      this.handleTaps = true,
      this.ignoreVerticalSwipes = true,
      this.customOnTap});

  final void Function() onRight;
  final void Function() onLeft;
  final VoidCallback? customOnTap;
  final Widget child;
  final bool handleTaps;
  final bool ignoreVerticalSwipes;
  static const minSwipeTimeMillis = 400;
  static const minKeyboardSwipeTimeMillis = 200;

  @override
  State<SliderGestureHandler> createState() => _SliderGestureHandlerState();
}

class _SliderGestureHandlerState extends State<SliderGestureHandler> {
  final _focusNode = FocusNode();

  var lastSwipeTime = DateTime.now();

  var lastTapDownTime = DateTime.now().subtract(const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.physicalKey == PhysicalKeyboardKey.arrowRight ||
        event.physicalKey == PhysicalKeyboardKey.pageUp) {
      widget.onRight();
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
        event.physicalKey == PhysicalKeyboardKey.pageDown) {
      widget.onLeft();
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
        onTapUp: widget.handleTaps
            ? (TapUpDetails details) => _tapHandler(details, context)
            : (TapUpDetails details) {},
        child: widget.child,
      ),
    );
  }

  void _swipeHandler(DragUpdateDetails details) {
    const int sensitivity = 2;
    var cur = DateTime.now();
    // debugPrint('${cur.difference(lastSwipeTime).inMilliseconds}/$minSlideChangeDelayMillis');
    if (cur.difference(lastSwipeTime).inMilliseconds <=
        SliderGestureHandler.minSwipeTimeMillis) {
      return;
    }
    if (widget.ignoreVerticalSwipes &&
        details.delta.dy.abs() > details.delta.dx.abs()) {
      return;
    }
    if (details.delta.dx > sensitivity) {
      lastSwipeTime = cur;
      widget.onLeft();
    }
    if (details.delta.dx < -sensitivity) {
      lastSwipeTime = cur;
      widget.onRight();
    }
  }

  void _tapHandler(TapUpDetails details, BuildContext context) {
    if (widget.customOnTap != null) {
      widget.customOnTap!();
      return;
    }
    if (DateTime.now().difference(lastTapDownTime).inMilliseconds > 1000) {
      return;
    }
    RenderBox box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    final x = localOffset.dx;
    if (x < box.size.width / 2) {
      widget.onLeft();
    } else {
      widget.onRight();
    }
  }
}
