import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';

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
  bool _pressed = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  static double fontSize(BuildContext context) =>
      Config.isDesktop(context) ? 18 : 14;

  static double radius(BuildContext context) =>
      Config.isDesktop(context) ? 22 : 20;

  Color get pressedColor => Config.darkModeOn ? ClassicButton.hoverColor :
      Colors.grey.shade200;

  Color get color => _pressed ? ClassicButton.hoverColor : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: Config.borderRadiusLarge,
      hoverColor: pressedColor,
      onTap: () {
        setState(() {
          _pressed = true;
        });
        Future.delayed(Config.shortAnimationTime, () {
          widget.onClicked();
          _pressed = false;
          if (_disposed) return;
          setState(() {
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.all(Config.padding),
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
