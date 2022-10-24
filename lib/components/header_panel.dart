import 'package:flutter/material.dart';

import 'package:voice_recipe/screens/home_screen.dart';
import 'package:voice_recipe/components/notifications/slide_notification.dart';

class HeaderPanel extends StatelessWidget {
  const HeaderPanel({super.key});

  final double _iconSize = 25;
  final double _panelHeight = 45;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: _panelHeight,
            width: _panelHeight,
            child: Image.asset("assets/images/voice_recipe.png")),
        Row(
          children: [
            buildButton(
              context,
              IconButton(
                onPressed: () => _onList(context),
                icon: Icon(
                  Icons.list,
                  color: Colors.black,
                  size: _iconSize,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            buildButton(
              context,
              IconButton(
                onPressed: () => _onClose(context),
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.black,
                  size: _iconSize,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  static Container buildButton(BuildContext context, IconButton iconButton) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: iconButton);
  }

  void _onClose(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Home()));
  }

  void _onList(BuildContext context) {
    SlideNotification n = SlideNotification(slideId: 1);
    n.dispatch(context);
  }
}
