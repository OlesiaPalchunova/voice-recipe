import 'package:flutter/material.dart';

class Util {
  static const borderRadius = 6.0;
  static const borderRadiusLarge = 16.0;
  static const padding = 10.0;
  static const margin = 10.0;
  static const backColors = [
    Color(0xFFE9F7CA),
    Color(0xFFF9C784),
    Color(0xFFf7d2ca),
    Color(0xFFf7ecca)
  ];
  static const colors = [
    Colors.green,
    Colors.orange,
    Colors.redAccent,
    Colors.orangeAccent
  ];

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
