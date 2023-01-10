import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/config.dart';

class AnimatedButton extends StatelessWidget {
  AnimatedButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.fontSize = 20
  }) : super(key: key) {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
  }

  final String text;
  late final RiveAnimationController _btnAnimationController;
  final VoidCallback onTap;
  final double fontSize;
  bool locked = false;

  String get postfix => Config.darkModeOn ? "_dark" : "_light";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (locked) return;
        locked = true;
        _btnAnimationController.isActive = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          onTap();
          locked = false;
        });
      },
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
