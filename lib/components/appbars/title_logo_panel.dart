import 'package:flutter/material.dart';

import '../../config.dart';

class TitleLogoPanel extends StatelessWidget {
  const TitleLogoPanel({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Text(
          title,
          style: const TextStyle(
              fontFamily: Config.fontFamilyBold,
              fontSize: 22,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
        Container(
            padding: const EdgeInsets.all(5),
            width: 50,
            child: Image.asset("assets/images/voice_recipe.png")),
      ],
    );
  }
}
