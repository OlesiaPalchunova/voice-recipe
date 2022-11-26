import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_recipe/themes/dark_theme_preference.dart';
import 'package:voice_recipe/translator.dart';

class GradientColors {
  final List<Color> colors;

  GradientColors(this.colors);

  static const List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static const List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static const List<Color> forest = [Color(0xFF27b03b), Color(0xFF5afa71)];
  static const List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static const List<Color> mango = [Color(0xFFFFA738), Color(0xFFfcdd1e)];
  static const List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
  static const List<List<Color>> sets = [sky, sunset, sea, mango, fire];
}

class Config {
  static const fontFamily = "Montserrat";
  static const fontFamilyBold = "MontserratBold";
  static const borderRadius = 6.0;
  static const borderRadiusLarge = 16.0;
  static const padding = 10.0;
  static const margin = 10.0;
  static var darkModeOn = false;
  static const Duration shortAnimationTime = Duration(milliseconds: 150);
  static const Duration animationTime = Duration(milliseconds: 200);
  static const MAX_SLIDE_WIDTH = 700.0;
  static const MAX_WIDTH = 1200.0;

  static init() async {
    darkModeOn = await DarkThemePreference().getTheme();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: _darkThemeBackColor,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  static setDarkModeOn(bool on) {
    darkModeOn = on;
    DarkThemePreference().setDarkTheme(on);
  }

  static const _darkThemeBackColor = Color(0xff171717); //Color(0xFF242634);
  static const _darkIconBackColor = Color(0xFF202124);
  static const darkBlue = Color(0xFF242634);
  static const _darkIconColor = Colors.white;

  static const _iconBackColor = Colors.white;
  static const _iconDisabledBackColor = Colors.white70;
  static const _iconColor = Colors.black87;

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

  static const Map<int, Color> colorScheme = {
    50: Color.fromRGBO(237, 120, 47, .1),
    100: Color.fromRGBO(237, 120, 47, .2),
    200: Color.fromRGBO(237, 120, 47, .3),
    300: Color.fromRGBO(237, 120, 47, .4),
    400: Color.fromRGBO(237, 120, 47, .5),
    500: Color.fromRGBO(237, 120, 47, .6),
    600: Color.fromRGBO(237, 120, 47, .7),
    700: Color.fromRGBO(237, 120, 47, .8),
    800: Color.fromRGBO(237, 120, 47, .9),
    900: Color.fromRGBO(237, 120, 47, 1),
  };

  static bool get loggedIn => FirebaseAuth.instance.currentUser != null;

  static Color get appBarColor {
    return Config.darkModeOn ? Colors.black87 : Colors.white;
  }

  static Color get notPressed {
    if (darkModeOn) {
      return _darkThemeBackColor;
    }
    return Colors.white;
  }

  static Color get pressed {
    if (darkModeOn) {
      return darkBlue;
    }
    return Colors.grey.shade100;
  }

  static Color get backgroundColor {
    if (darkModeOn) {
      return _darkThemeBackColor;
    }
    return Colors.white;
  }

  static Color get iconBackColor {
    if (darkModeOn) {
      return _darkIconBackColor;
    }
    return _iconBackColor;
  }

  static Color get disabledIconBackColor {
    if (darkModeOn) {
      return darkBlue;
    }
    return _iconDisabledBackColor;
  }

  static Color get iconColor {
    if (darkModeOn) {
      return _darkIconColor;
    }
    return _iconColor;
  }

  static List<Color> getGradientColor(int id) {
    return GradientColors.sets[id % GradientColors.sets.length];
  }

  static Color getColor(int id) {
    if (darkModeOn) {
      return GradientColors.sets[id % GradientColors.sets.length].last;
    }
    return colors[id % colors.length];
  }

  static void showAlertDialog(String text, BuildContext context) async {
    final russianText = await Translator().translateToRu(text);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Config.backgroundColor,
          content: Text(
            russianText,
            style: TextStyle(
                color: Config.iconColor,
                fontFamily: Config.fontFamily,
                fontSize: 20),
          ),
        ));
  }

  static Color lastBackColor = _darkThemeBackColor;

  static Color getBackColor(int id) {
    if (darkModeOn) {
      lastBackColor = _darkThemeBackColor;
      return _darkThemeBackColor;
    }
    lastBackColor = backColors[id % backColors.length];
    return backColors[id % backColors.length];
  }

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return min(MAX_WIDTH, MediaQuery.of(context).size.width);
  }

  static double slideWidth(BuildContext context) {
    return min(MAX_SLIDE_WIDTH, pageWidth(context));
  }

  static bool isDesktop(BuildContext context) {
    return pageWidth(context) >= pageHeight(context);
  }

  static var notificationsOn = true;
}
