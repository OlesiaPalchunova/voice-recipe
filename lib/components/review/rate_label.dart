import 'package:flutter/material.dart';

import '../../config.dart';

class RateLabel extends StatelessWidget {
  const RateLabel({super.key, required this.rate, this.width = 80,
  this.justDark = false});

  final double rate;
  final double width;
  final bool justDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.black87, width: 0.1),
          color: (Config.darkModeOn | justDark) ? Config.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(Config.borderRadiusLarge)),
      width: width,
      height: width / 2,
      padding: EdgeInsets.all(width / 20).add(EdgeInsets.symmetric(horizontal:
      width / 15)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow.shade700,
            size: width / 3,
          ),
          Text(
            rate.toString(),
            style: TextStyle(
                fontFamily: Config.fontFamily,
                color: justDark ? Colors.white : Config.iconColor,
                fontSize: width / 4),
          )
        ],
      ),
    );
  }
}
