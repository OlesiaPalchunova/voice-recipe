import 'package:flutter/material.dart';
import 'package:voice_recipe/components/labels/time_label.dart';

import 'package:voice_recipe/model/recipes_info.dart';
import 'package:voice_recipe/config/config.dart';

class RecipeFaceSlideView extends StatelessWidget {
  const RecipeFaceSlideView({
    Key? key,
    required this.recipe,
    required this.goToLastSlide,
  }) : super(key: key);

  final Recipe recipe;
  final void Function() goToLastSlide;

  double titleFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 26 : 24;

  double timeFontSize(BuildContext context) =>
      Config.isDesktop(context) ? 20 : 18;



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          height: screenHeight * .65,
          margin: const EdgeInsets.all(Config.margin * .5),
          //     .add(const EdgeInsets.only(bottom: Config.margin)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: Config.borderRadiusLarge,
            image: DecorationImage(
              image: NetworkImage(recipe.faceImageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Config.getBackColor(recipe.id).withOpacity(.8),
                ),
                padding: const EdgeInsets.all(Config.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimeLabel(
                      time: TimeLabel.convertToTOD(recipe.cookTimeMins),
                      iconSize: 24,
                      customFontSize: timeFontSize(context),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontFamily: Config.fontFamily,
                              fontSize: titleFontSize(context),
                              color: Config.iconColor),
                          children: <TextSpan>[TextSpan(text: recipe.name)]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          // color: Config.getColor(recipe.id),
          color: Colors.white70,
          margin: const EdgeInsets.all(Config.margin * .5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.comment),
              ),
              TextButton(
                onPressed: goToLastSlide,
                // style: ButtonStyle(
                //   backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //     RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                // ),
                child: Text(
                  'Перейти на слайд с отзывами',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
