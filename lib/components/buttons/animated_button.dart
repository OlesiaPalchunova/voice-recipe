import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/config.dart';

class AnimatedButton extends StatelessWidget {
  const AnimatedButton({
    Key? key,
    required RiveAnimationController btnAnimationController,
    required this.onTap,
    required this.text,
    this.fontSize = 20
  })  : _btnAnimationController = btnAnimationController,
        super(key: key);

  final String text;
  final RiveAnimationController _btnAnimationController;
  final VoidCallback onTap;
  final double fontSize;

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHover: (h) {},
      child: SizedBox(
        height: 64,
        // width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/button$postfix.riv",
              controllers: [_btnAnimationController],
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                    color: Config.iconColor,
                    fontSize: fontSize,
                    fontFamily: Config.fontFamily
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
