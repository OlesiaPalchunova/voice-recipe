import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:blur/blur.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/screens/create_recipe_screen.dart';
import 'package:voice_recipe/components/recipe_header_card.dart';

import '../config.dart';
import 'buttons/animated_button.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({super.key});

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  static double generalFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

  static double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 24 : 20;

  double labelWidth(BuildContext context) {
    double k = Config.isWide(context) ? .45 : .9;
    return k * width(context);
  }

  double width(BuildContext context) {
    double cardWidth = RecipeHeaderCard.cardWidth(context);
    int n = 1;
    while (true) {
      double margin = 2 * 10.0 * (n - 1);
      if (Config.widePageWidth(context) < n * cardWidth + margin) {
        n--;
        break;
      }
      n++;
    }
    double margin = 2 * 10.0 * (n - 1);
    return n * cardWidth + margin;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Config.darkThemeProvider,
      builder: (context, darkModeOn, child) {
        return Container(
          height: 220,
          alignment: Alignment.center,
          width: width(context),
          decoration: const BoxDecoration(
            borderRadius: Config.borderRadiusLarge,
          ),
          child: Blur(
            blur: 5,
            blurColor: Config.edgeColor,
            borderRadius: Config.borderRadiusLarge,
            overlay: Container(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                padding: Config.paddingAll,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Творите. Создавайте. Вдохновляйте.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: darkModeOn ? Colors.white : Colors.black,
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
                      width: labelWidth(context) / 2,
                      child: AnimatedButton(
                          onTap: () {
                            Routemaster.of(context).push(CreateRecipeScreen.route);
                          },
                          text: "Перейти"
                      )
                    )
                  ],
                ),
              ),
            ),
            child: Container(
                alignment: Alignment.center,
                child: const SizedBox(
                    child: RiveAnimation.asset('assets/RiveAssets/shapes.riv',
                    )
                )
            ),
          ),
        );
      }
    );
  }
}
