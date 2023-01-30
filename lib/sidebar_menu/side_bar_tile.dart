import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';

import '../config/config.dart';

class SideBarTile extends StatefulWidget {
  const SideBarTile(
      {super.key,
      required this.name,
      required this.onClicked,
      required this.iconData,
      required this.activeIconData});

  final String name;
  final VoidCallback onClicked;
  final IconData iconData;
  final IconData activeIconData;

  @override
  State<SideBarTile> createState() => _SideBarTileState();
}

class _SideBarTileState extends State<SideBarTile> {
  bool pressed = false;
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  static double fontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 14;

  static double radius(BuildContext context) =>
      Config.isDesktop(context) ? 22 : 20;

  Color get pressedColor => Config.darkModeOn ? const Color(0xFF303030) :
  const Color(0xFFFbF2F1).darken(2);

  Color get color => pressed ? pressedColor : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: Config.borderRadiusLarge,
      hoverColor: pressedColor,
      onTap: () {
        setState(() {
          pressed = true;
        });
        Future.delayed(Config.shortAnimationTime, () {
          widget.onClicked();
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          pressed = false;
          if (disposed) return;
          setState(() {
          });
        });
      },
      child: Container(
        padding: Config.paddingAll,
        decoration: BoxDecoration(
          color: color,
          borderRadius: Config.borderRadiusLarge
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.orangeAccent, blurRadius: 6, spreadRadius: 1.0)
                    ],
                  ),
                  child: CircleAvatar(
                    radius: radius(context),
                    backgroundColor: Config.backgroundColor,
                    child: Icon(
                      pressed? widget.activeIconData : widget.iconData,
                      color: Config.iconColor,
                      size: radius(context),
                    ),
                  )
                ),
                const SizedBox(width: Config.margin * 2),
                Config.defaultText(widget.name, fontSize: fontSize(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
