import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:blur/blur.dart';
import 'package:voice_recipe/screens/create_recipe_screen.dart';

import '../config.dart';
import 'buttons/animated_button.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({super.key});

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

double width(BuildContext context) {
  double k = Config.isWide(context) ? .45 : .9;
  return k * Config.pageWidth(context);
}

class _AdvertisementState extends State<Advertisement> {
  late RiveAnimationController _btnAnimationController;
  static double generalFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

  static double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 24 : 22;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      alignment: Alignment.center,
      width: Config.pageWidth(context) * .9,
      decoration: BoxDecoration(
          borderRadius: Config.borderRadiusLarge,
          color: Config.backgroundColor,
          boxShadow: [
            BoxShadow(
                color: Config.iconColor, spreadRadius: 0.2, blurRadius: 0.2)
          ]
      ),
      child: Blur(
        blur: 5,
        blurColor: Config.backgroundColor,
        borderRadius: Config.borderRadiusLarge,
        overlay: Container(
          alignment: Alignment.centerLeft,
          child: Container(
            width: width(context),
            alignment: Alignment.center,
            padding: Config.paddingAll,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Творите. Создавайте. Вдохновляйте',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Config.darkModeOn ? Colors.white : Colors.black,
                      fontFamily: Config.fontFamily,
                      fontSize: titleFontSize(context)),
                ),
                const SizedBox(height: Config.margin,),
                Text(
                  'Переходите в самый удобный конструктор рецептов и покажите всему миру своё кулинарное мастерство',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Config.iconColor.withOpacity(.8),
                      fontFamily: Config.fontFamily,
                      fontSize: generalFontSize(context)),
                ),
                const SizedBox(height: Config.margin,),
                SizedBox(
                  width: width(context) / 2,
                  child: AnimatedButton(
                      btnAnimationController: _btnAnimationController,
                      onTap: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          Navigator.of(context).pushNamed(CreateRecipeScreen.route);
                        });
                      },
                      text: "Перейти"
                  ),
                )
              ],
            ),
          ),
        ),
        child: Container(
            alignment: Alignment.centerRight,
            child: SizedBox(
                width: width(context),
                child: const RiveAnimation.asset('assets/RiveAssets/shapes.riv')
            )
        ),
      ),
    );
  }
}
