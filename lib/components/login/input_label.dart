import 'package:flutter/material.dart';

import '../../config.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    required this.hintText,
    required this.iconData,
    this.height = 60
  });

  final String hintText;
  final IconData iconData;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.brown[50],
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(Config.padding),
                  child: Icon(
                    iconData,
                    color: Colors.brown,
                  ),
                ),
                Text(
                  hintText,
                  style: const TextStyle(
                      color: Colors.brown, fontSize: 18,
                      fontFamily: Config.fontFamily),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
