import 'package:flutter/material.dart';

class Config {
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

  static const Map<int, Color> colorScheme =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
