import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

class TitleLogoPanel extends StatefulWidget {
  const TitleLogoPanel({super.key, required this.title});

  final String title;

  @override
  State<TitleLogoPanel> createState() => _TitleLogoPanelState();

  AppBar appBar() {
    return AppBar(
        foregroundColor: Config.iconColor,
        backgroundColor: Config.appBarColor,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Config.iconColor,
            size: 25),
        leadingWidth: 70,
        toolbarHeight: 70,
        title: this);
  }
}

class _TitleLogoPanelState extends State<TitleLogoPanel> {
  void update() {
    setState(() {});
  }

  double fontSize(BuildContext context) => Config.isDesktop(context) ? 22 : 20;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Config.darkThemeProvider,
        builder: (BuildContext context, bool darkModeOn, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                widget.title,
                style: TextStyle(
                    fontFamily: Config.fontFamily,
                    fontSize: fontSize(context),
                    fontWeight: FontWeight.normal,
                    color: Config.iconColor),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  width: 40,
                  child: Image.asset("assets/images/voice_recipe.png")),
            ],
          );
        });
  }
}
