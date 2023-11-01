import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

class TitleUserPanel extends StatefulWidget {
  const TitleUserPanel({key, required this.title});

  final String title;

  @override
  State<TitleUserPanel> createState() => _TitleUserPanelState();

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


class _TitleUserPanelState extends State<TitleUserPanel> {
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
              Text(
                widget.title,
                style: TextStyle(
                    fontFamily: Config.fontFamily,
                    fontSize: fontSize(context),
                    fontWeight: FontWeight.normal,
                    color: Config.iconColor),
              ),
            ],
          );
        });
  }
}
