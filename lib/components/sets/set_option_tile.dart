import 'package:flutter/material.dart';

import '../../config.dart';
import '../../model/sets_info.dart';
import '../../screens/set_screen.dart';

class SetOptionTile extends StatefulWidget {
  const SetOptionTile({Key? key, required this.setOption}) : super(key: key);

  final SetOption setOption;

  @override
  State<SetOptionTile> createState() => _SetOptionTileState();
}

class _SetOptionTileState extends State<SetOptionTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = true;
        });
      },
      child: AnimatedContainer(
        duration: Config.shortAnimationTime,
        onEnd: () async {
          if (_isPressed) {
            _navigateToSet(context, widget.setOption);
          }
          a() {
            setState(() {
              _isPressed = false;
            });
          }
          await Future.delayed(Config.animationTime).whenComplete(a);
        },
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Config.borderRadius),
          color: _isPressed ? Config.pressed : Config.notPressed,
        ),
        width: Config.pageWidth(context),
        margin: const EdgeInsets.symmetric(horizontal: Config.margin * 2),
        padding: const EdgeInsets.symmetric(
                vertical: Config.padding * 0.5,
                horizontal: Config.padding * 0.5)
            .add(const EdgeInsets.only(top: 0.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.setOption.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: Config.fontFamily,
                          fontWeight: FontWeight.w500,
                          color: Config.iconColor)),
                  Text(
                    widget.setOption.getRecipes().length.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: Config.fontFamily,
                        fontWeight: FontWeight.w500,
                        color: Config.iconColor),
                  ),
                ]),
            Divider(
              color: _isPressed ? Config.pressed : Config.iconColor.withOpacity(0.5),
              thickness: 0.2,
              indent: 0.0,
              endIndent: 0.0,
            )
          ],
        ),
      ),
    );
  }

  void _navigateToSet(BuildContext context, SetOption setOption) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SetScreen(setOption: setOption)));
  }
}
