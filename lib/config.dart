import 'package:flutter/material.dart';

class Config {
  static const borderRadius = 6.0;
  static const borderRadiusLarge = 16.0;
  static const padding = 10.0;
  static const margin = 10.0;

  static const iconBackColor = Colors.white;
  static const iconDisabledBackColor = Colors.white70;
  static const iconColor = Colors.black87;

  static const backColors = [
    Color(0xFFE9F7CA),
    Color(0xFFF9C784),
    Color(0xFFf7d2ca),
    Color(0xFFf7ecca)
  ];

  static const colors = [
    Color(0xff61cc45),
    Colors.orange,
    Colors.redAccent,
    Colors.orangeAccent
  ];

  static Color getColor(int id) {
    return colors[id % colors.length];
  }

  static Color getBackColor(int id) {
    return backColors[id % backColors.length];
  }

  static const Map<int, Color> colorScheme =
  {
    50:Color.fromRGBO (237, 120, 47, .1),
    100:Color.fromRGBO(237, 120, 47, .2),
    200:Color.fromRGBO(237, 120, 47, .3),
    300:Color.fromRGBO(237, 120, 47, .4),
    400:Color.fromRGBO(237, 120, 47, .5),
    500:Color.fromRGBO(237, 120, 47, .6),
    600:Color.fromRGBO(237, 120, 47, .7),
    700:Color.fromRGBO(237, 120, 47, .8),
    800:Color.fromRGBO(237, 120, 47, .9),
    900:Color.fromRGBO(237, 120, 47, 1),
  };

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static var notificationsOn = true;
}
