import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class SideBarTile extends StatefulWidget {
  const SideBarTile(
      {super.key,
      required this.name,
      required this.onClicked,
      required this.iconData});

  final String name;
  final VoidCallback onClicked;
  final IconData iconData;

  @override
  State<SideBarTile> createState() => _SideBarTileState();
}

class _SideBarTileState extends State<SideBarTile> {

  static double fontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 16;

  static double radius(BuildContext context) =>
      Config.isDesktop(context) ? 22 : 20;

  Color get pressedColor => Config.darkModeOn ? Config.darkBlue :
      Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
      hoverColor: pressedColor,
      onTap: widget.onClicked,
      child: Container(
        padding: const EdgeInsets.all(Config.padding),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.orangeAccent, blurRadius: 6)
                    ],
                  ),
                  child: CircleAvatar(
                    radius: radius(context),
                    backgroundColor: Config.backgroundColor,
                    child: Icon(
                      widget.iconData,
                      color: Config.iconColor,
                      size: radius(context),
                    ),
                  )
                ),
                const SizedBox(width: Config.margin * 2),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: fontSize(context),
                    color: Config.iconColor,
                    fontFamily: Config.fontFamily,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
