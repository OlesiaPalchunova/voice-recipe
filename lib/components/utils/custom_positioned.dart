import 'package:flutter/cupertino.dart';

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child,
  this.topOffset = 100});

  final double scale;
  final Widget child;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
    );
  }
}
