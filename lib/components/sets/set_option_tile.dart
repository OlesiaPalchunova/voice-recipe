import 'package:flutter/cupertino.dart';
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
        onEnd: () {
          if (_isPressed) {
            _navigateToSet(context, widget.setOption);
          }
          setState(() {
            _isPressed = false;
          });
        },
        decoration: BoxDecoration(
            border: Border.all(color: Config.iconColor(), width: 0.2),
            borderRadius: BorderRadius.circular(Config.borderRadius),
            color:
                _isPressed ? Config.pressed() : Config.notPressed(),
        ),
        width: Config.pageWidth(context),
        margin: const EdgeInsets.symmetric(
            vertical: Config.margin * 0.5, horizontal: Config.margin * 2),
        padding: const EdgeInsets.all(Config.padding * 1.5),
        child: Stack(
          children: [
            Text(
            widget.setOption.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontFamily: Config.fontFamily,
                fontWeight: FontWeight.w500,
                color: Config.iconColor()
            ),
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  widget.setOption.getRecipes().length.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: Config.fontFamily,
                      fontWeight: FontWeight.w500,
                      color: Config.iconColor()
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

  void _navigateToSet(BuildContext context, SetOption setOption) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SetScreen(
              setOption: setOption,
            )));
  }
}
