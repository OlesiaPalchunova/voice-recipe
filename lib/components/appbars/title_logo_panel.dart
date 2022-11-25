import 'package:flutter/material.dart';

import '../../config.dart';

class TitleLogoPanel extends StatefulWidget {
  const TitleLogoPanel({super.key, required this.title});

  final String title;

  @override
  State<TitleLogoPanel> createState() => TitleLogoPanelState();

  AppBar appBar() {
    return AppBar(
      foregroundColor: Config.iconColor,
      backgroundColor: Config.backgroundColor,
      title: this
    );
  }
}

class TitleLogoPanelState extends State<TitleLogoPanel> {
  static TitleLogoPanelState? _current;

  @override
  initState() {
    super.initState();
    _current ??= this;
  }

  static TitleLogoPanelState? get current => _current;

  void update() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            widget.title,
            style: TextStyle(
                fontFamily: Config.fontFamily,
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Config.iconColor
            ),
          ),
          Container(
              padding: const EdgeInsets.all(5),
              width: 50,
              child: Image.asset("assets/images/voice_recipe.png")
          ),
        ],
    );
  }
}
