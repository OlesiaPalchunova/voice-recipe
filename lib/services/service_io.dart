import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/config/config.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/pages/account/login_page.dart';
import 'package:voice_recipe/services/translator.dart';

import '../model/users_info.dart';
import 'auth/Token.dart';
import 'auth/auth.dart';

class ServiceIO {
  static bool isToken = false;
  static User? get user => FirebaseAuth.instance.currentUser;

  static String get profileImageUrl =>
      loggedIn ? user!.photoURL ?? defaultProfileUrl : defaultProfileUrl;

  // static bool get loggedIn => FirebaseAuth.instance.currentUser != null;
  static void setToken(){
    isToken = true;
  }
  // static bool get loggedIn => isToken;
  static bool get loggedIn {
    print("444444444444444444444444444444");
    print(Token.isToken());
    return Token.isToken();
  }

  static double fontSize(BuildContext context) => Config.isDesktop(context) ?
      20 : 18;

  static void setPageTitle(String title, BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
      label: title,
      primaryColor: Theme.of(context).primaryColor.value, // This line is required
    ));
  }

  static void showLoginInviteDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.all(Config.padding * 2),
          actionsPadding: const EdgeInsets.all(Config.padding * 2),
          backgroundColor: Config.backgroundEdgeColor,
          content: Text(
            "Войдите, чтобы сохранять понравившиеся\nрецепты и оставлять комментарии",
            style: TextStyle(
                color: Config.iconColor, fontFamily: Config.fontFamily, fontSize: 18),
          ),
          actions: [
            ClassicButton(
              text: "Войти",
              fontSize: fontSize(context),
              onTap: () {
                Routemaster.of(context).pop();
                Routemaster.of(context).push(LoginPage.route);
              },
            )
          ],
        ));
  }

  static Future<TimeOfDay?> showTimeInputDialog(BuildContext context, String helpText,
      [TimeOfDay initialTime = const TimeOfDay(hour: 0, minute: 0)]) async {
    TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        helpText: helpText,
        initialEntryMode: TimePickerEntryMode.dial,
        hourLabelText: "Часы",
        minuteLabelText: "Минуты",
        initialTime: initialTime
    );
    return selectedTime;
  }

  static void showAlertDialog(String text, BuildContext context,
      [bool noShadow = false]) async {
    final russianText = await Translator().translateToRu(text);
    final fixedText = russianText.replaceAll('Давая', 'Данная');
    showDialog(
        barrierColor: noShadow ? Colors.transparent : Colors.black54,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Config.backgroundEdgeColor,
          content: Text(
            fixedText,
            style: TextStyle(
                color: Config.iconColor,
                fontFamily: Config.fontFamily,
                fontSize: fontSize(context)),
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
}
