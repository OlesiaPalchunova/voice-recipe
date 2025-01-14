import 'package:flutter/material.dart';

import '../../config/config.dart';

class RateLabel extends StatelessWidget {
  const RateLabel({key, required this.rate, this.width = 80,
  this.shadowOn = true});

  final double rate;
  final double width;
  final bool shadowOn;

  List<BoxShadow> get shadows => [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Config.edgeColor,
          borderRadius: Config.borderRadiusLarge,
        boxShadow: shadows
      ),
      margin: EdgeInsets.only(bottom: width / 10),
      width: width,
      height: width * .8,
      padding: EdgeInsets.all(width / 20).add(EdgeInsets.symmetric(horizontal:
      width / 15)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow.shade900,
            size: width / 3,
          ),
          Text(
            rate.toString(),
            style: TextStyle(
                fontFamily: "Roboto",
                // fontWeight: FontWeight.w700,
                color: !Config.darkModeOn ? Colors.black87 : Colors.white,
                fontSize: width / 4
            ),
          )
        ],
      ),
    );
  }
}
