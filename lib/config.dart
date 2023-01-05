import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/model/users_info.dart';
import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/screens/authorization/login_screen.dart';
import 'package:voice_recipe/theme_manager/dark_theme_preference.dart';
import 'package:voice_recipe/services/translator.dart';
import 'package:voice_recipe/api/recipes_getter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

class Config {
  static const appName = "Talky Chef";
  static const fontFamily = "Montserrat";
  static const fontFamilyBold = "MontserratBold";
  static const radius = 6.0;
  static const largeRadius = 16.0;
  static const padding = 10.0;
  static const margin = 10.0;
  static var darkModeOn = false;
  static const Duration shortAnimationTime = Duration(milliseconds: 150);
  static const Duration animationTime = Duration(milliseconds: 200);
  static const maxRecipeSlideWidth = 600.0;
  static const maxConstructorWidth = 1000.0;
  static const maxPageWidth = 1200.0;
  static const maxLoginPageWidth = 500.0;
  static const maxLoginPageHeight = 800.0;
  static const minLoginPageWidth = 300.0;
  static const minLoginPageHeight = 500.0;
  static const borderRadius = BorderRadius.all(Radius.circular(radius));
  static const borderRadiusLarge = BorderRadius.all(Radius.circular(largeRadius));
  static const backGroundDecorationImage = DecorationImage(
      image: AssetImage("assets/images/decorations/create_back.jpg"),
      fit: BoxFit.cover);

  static init() async {
    var mainPage = await RecipesGetter().getCollection('mainpage');
    if (mainPage != null) {
      recipes.addAll(mainPage);
    }
    darkModeOn = await DarkThemePreference().getTheme();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: _darkThemeBackColor,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  static setDarkModeOn(bool on) {
    darkModeOn = on;
    DarkThemePreference().setDarkTheme(on);
  }

  static EdgeInsetsGeometry get paddingAll => const EdgeInsets.all(padding);
  static EdgeInsetsGeometry get paddingVert => const EdgeInsets.symmetric(vertical: padding);

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

  static bool get isWeb => kIsWeb;

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

  static final lightTheme = ThemeData(
      primarySwatch: const MaterialColor(
          0xFFf07800,
          Config.colorScheme
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
          color: MaterialColor(
              0xFFf07800,
              Config.colorScheme
          )
      )
  );

  static final darkTheme = ThemeData(
      bottomAppBarTheme: const BottomAppBarTheme(
          color: MaterialColor(0xFFf07800, Config.colorScheme)),
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch:
          const MaterialColor(0xFFf07800, Config.colorScheme))
          .copyWith(
          background: const MaterialColor(0xff000000, Config.colorScheme)));

  static String get profileImageUrl => loggedIn ?
      user!.photoURL?? defaultProfileUrl : defaultProfileUrl;

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

  static Color get edgeColor => darkModeOn ? darkBlue : Colors.white;

  static List<Color> getGradientColor(int id) {
    return GradientColors.sets[id % GradientColors.sets.length];
  }

  static Color getColor(int id) {
    if (darkModeOn) {
      // return Colors.orange;
      return GradientColors.sets[id % GradientColors.sets.length].last;
    }
    return colors[id % colors.length];
  }

  static User? get user => FirebaseAuth.instance.currentUser;

  static void showLoginInviteDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(Config.padding * 2),
            actionsPadding: const EdgeInsets.all(Config.padding * 2),
            backgroundColor: Config.backgroundColor,
              content: Text(
                "Войдите, чтобы сохранять понравившиеся\nрецепты и оставлять комментарии",
                style: TextStyle(
                    color: iconColor,
                    fontFamily: fontFamily,
                    fontSize: 18
                ),
              ),
              actions: [
                ClassicButton(
                  text: "Войти",
                  fontSize: 20,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)
                    => const LoginScreen()));
                  },
                )
              ],
            ));
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

  static void showProgressCircle(BuildContext context) {
    showDialog(
        context: context,
        builder: (content) => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  static Color getBackColor(int id) {
    if (darkModeOn) {
      return _darkThemeBackColor;
    }
    return backColors[id % backColors.length];
  }

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double recipeSlideWidth(BuildContext context) {
    return min(maxRecipeSlideWidth, pageWidth(context));
  }

  static double constructorWidth(BuildContext context) {
    return min(maxConstructorWidth, pageWidth(context));
  }

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

  static bool isDesktop(BuildContext context) {
    return pageWidth(context) >= pageHeight(context);
  }

  static var notificationsOn = true;
}
