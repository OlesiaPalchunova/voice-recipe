import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_recipe/theme_manager/dark_theme_preference.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../components/appbars/title_logo_panel.dart';

class GradientColors {
  final List<Color> colors;

  GradientColors(this.colors);

  static const List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static const List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static const List<Color> forest = [Color(0xFF27b03b), Color(0xFF5afa71)];
  static const List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static const List<Color> mango = [Color(0xFFFFA738), Color(0xFFfcdd1e)];
  static const List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
  static const List<List<Color>> sets = [forest, sky, sunset, sea, mango, fire];
}

enum AppTheme { dark, light }

class Config {
  static ValueNotifier<bool> darkThemeProvider = ValueNotifier(false);

  static const appName = "Talky Chef";
  static const fontFamily = "Montserrat";
  static const fontFamilyBold = "MontserratBold";
  static const radius = 6.0;
  static const largeRadius = 16.0;
  static const padding = 10.0;
  static const margin = 10.0;

  static bool get darkModeOn => darkThemeProvider.value;
  static const Duration shortAnimationTime = Duration(milliseconds: 150);
  static const Duration animationTime = Duration(milliseconds: 200);
  static const maxRecipeSlideWidth = 600.0;
  static const maxConstructorWidth = 1000.0;
  static const maxAdWidth = 270.0 * 3 + 10.0 * 6;
  static const maxPageWidth = 1500.0;
  static const maxLoginPageWidth = 500.0;
  static const maxLoginPageHeight = 800.0;
  static const minLoginPageWidth = 300.0;
  static const minLoginPageHeight = 500.0;
  static const borderRadius = BorderRadius.all(Radius.circular(radius));
  static const borderRadiusLarge =
      BorderRadius.all(Radius.circular(largeRadius));
  static const backGroundDecorationImage = DecorationImage(
      image: AssetImage("assets/images/decorations/create_back.jpg"),
      fit: BoxFit.cover);
  static var notificationsOn = true;

  static AppBar get defaultAppBar =>
      const TitleLogoPanel(title: Config.appName).appBar();

  static init() async {
    darkThemeProvider.value = await DarkThemePreference().getTheme();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: darkThemeBackColor,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  static setDarkModeOn(bool on) {
    darkThemeProvider.value = on;
    DarkThemePreference().setDarkTheme(on);
  }

  static EdgeInsetsGeometry get paddingAll => const EdgeInsets.all(padding);

  static EdgeInsetsGeometry get paddingVert =>
      const EdgeInsets.symmetric(vertical: padding);

  static const darkThemeBackColor = Color(0xff171717); //Color(0xFF242634);
  static const darkIconBackColor = Color(0xFF202124);
  static const drawerScrimColor = Color.fromRGBO(17, 17, 17, .6);
  static const darkBlue = Color(0xFF242634);
  static const darkIconColor = Colors.white;

  static const lightIconBackColor = Colors.white;
  static const lightIconDisabledBackColor = Colors.white70;
  static const lightIconColor = Colors.black87;

  static bool get isWeb => kIsWeb;

  static const colors = [
    Color(0xff61cc45),
    Color(0xffcc9245),
    Colors.redAccent,
    Colors.orangeAccent
  ];

  static const lightBackColors = [
    Color(0xFFE9F7CA),
    Color(0xFFcae1f7),
    Color(0xfff7cae4),
    Color(0xFFcae1f7),
    Color(0xFFf7ecca),
    Color(0xFFf7d2ca),
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

  static final lightTheme = ThemeData(
      bottomAppBarTheme: const BottomAppBarTheme(
          color: MaterialColor(0xFFf07800, Config.colorScheme)),
      primarySwatch: const MaterialColor(0xFFf07800, Config.colorScheme));

  static final darkTheme = ThemeData(
      bottomAppBarTheme: const BottomAppBarTheme(
          color: MaterialColor(0xFFf07800, Config.colorScheme)),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch:
                  const MaterialColor(0xFFf07800, Config.colorScheme))
          .copyWith(
              background: const MaterialColor(0xff000000, Config.colorScheme)));

  static Color get appBarColor => darkModeOn ? Colors.black87 : Colors.white;

  static Color get notPressed => darkModeOn ? darkThemeBackColor : Colors.white;

  static Color get pressed => darkModeOn ? darkBlue : Colors.grey.shade100;

  static Color get backgroundColor =>
      darkModeOn ? darkThemeBackColor : Colors.white;

  static Color get backgroundEdgeColor =>
      darkModeOn ? darkThemeBackColor : Colors.grey.shade200;

  static Color get backgroundLightedColor =>
      darkModeOn ? Colors.grey.shade900 : Colors.white;

  static Color get iconBackColor =>
      darkModeOn ? darkIconBackColor : lightIconBackColor;

  static Color get disabledIconBackColor =>
      darkModeOn ? darkBlue : lightIconDisabledBackColor;

  static Color get iconColor => darkModeOn ? darkIconColor : lightIconColor;

  static Color get edgeColor => darkModeOn ? darkBlue : Colors.white;

  static List<Color> getGradientColor(int id) {
    return GradientColors.sets[id % GradientColors.sets.length];
  }

  static Color getColor(int id) => darkModeOn
      ? GradientColors.sets[id % GradientColors.sets.length].last
      : GradientColors.sets[id % GradientColors.sets.length].first;

  static Color getBackColor(int id) => darkModeOn
      ? darkThemeBackColor
      : lightBackColors[id % lightBackColors.length];

  static Color getBackEdgeColor(int id) =>
      darkModeOn ? darkBlue : lightBackColors[id % lightBackColors.length];

  static double pageHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double pageWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double widePageWidth(BuildContext context) =>
      min(maxPageWidth, MediaQuery.of(context).size.width);

  static double recipeSlideWidth(BuildContext context) =>
      min(maxRecipeSlideWidth, pageWidth(context));

  static double constructorWidth(BuildContext context) =>
      min(maxConstructorWidth, pageWidth(context));

  static double adWidth(BuildContext context) =>
      min(maxAdWidth, pageWidth(context));

  static double loginPageWidth(BuildContext context) {
    var pw = pageWidth(context);
    if (pw < minLoginPageWidth) return minLoginPageWidth;
    if (pw > maxLoginPageWidth) return maxLoginPageWidth;
    return pw;
  }

  static double loginPageHeight(BuildContext context) {
    var ph = pageHeight(context);
    if (ph < minLoginPageHeight) return minLoginPageHeight;
    if (ph > maxLoginPageHeight) return maxLoginPageHeight;
    return ph;
  }

  static bool isWide(BuildContext context) =>
      pageWidth(context) >= pageHeight(context) * 1.5;

  static bool isDesktop(BuildContext context) =>
      pageWidth(context) >= pageHeight(context);
}
