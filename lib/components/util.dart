import 'package:flutter/material.dart';

class Util {
  static const borderRadius = 6.0;
  static const padding = 10.0;
  static const margin = 10.0;

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
