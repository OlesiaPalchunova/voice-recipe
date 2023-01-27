import 'package:flutter/material.dart';

import '../../config.dart';
import '../../screens/constructor/create_recipe_screen.dart';
import '../buttons/classic_button.dart';
import '../buttons/delete_button.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({super.key, required this.time,
  this.iconSize = 20, this.customFontSize});

  final TimeOfDay time;
  final double iconSize;
  final double? customFontSize;

  static TimeOfDay convertToTOD(int mins) {
    int hours = 0;
    while (mins >= 60) {
      hours++;
      mins -= 60;
    }
    return TimeOfDay(hour: hours, minute: mins);
  }

  String get timeToStr {
    if (time.hour == 0) {
      return "${time.minute} мин.";
    }
    return "${time.hour} ч. ${time.minute} мин.";
  }

  double fontSize(BuildContext context) =>
    Config.isDesktop(context) ? 16 : 14;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.access_time,
        color: Config.iconColor,
        size: iconSize,
      ),
      const SizedBox(
        width: Config.margin / 2
      ),
      Container(
        height: iconSize,
        alignment: Alignment.centerLeft,
        child: Text(timeToStr,
            style: TextStyle(
                fontFamily: Config.fontFamily,
                fontSize: customFontSize?? fontSize(context),
                color: Config.iconColor)),
      )
    ]);
  }

  static Widget buildSetter(BuildContext context,
      {TimeOfDay? time,
        required String buttonText,
        required String labelText,
        required VoidCallback onSetTap,
        required VoidCallback onDeleteTap}) {
    return time == null
        ? ClassicButton(
      onTap: onSetTap,
      text: buttonText,
      fontSize: CreateRecipeScreen.generalFontSize(context),
    )
        : Container(
      decoration: BoxDecoration(
          color: CreateRecipeScreen.buttonColor.withOpacity(.9),
          borderRadius: Config.borderRadiusLarge),
      padding: const EdgeInsets.symmetric(horizontal: Config.padding),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText,
              style: TextStyle(
                  fontFamily: Config.fontFamily,
                  color: Config.iconColor,
                  fontSize: CreateRecipeScreen.generalFontSize(context)),
            ),
            SizedBox(
              width: CreateRecipeScreen.pageWidth(context) * .4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TimeLabel(time: time),
                  const SizedBox(
                    width: Config.margin / 2,
                  ),
                  DeleteButton(
                      margin: const EdgeInsets.symmetric(
                          horizontal: Config.margin),
                      onPressed: onDeleteTap)
                ],
              ),
            )
          ]),
    );
  }
}
