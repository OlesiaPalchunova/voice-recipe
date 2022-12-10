import 'package:flutter/material.dart';

import '../../config.dart';

class TimerDecoration extends StatelessWidget {
  const TimerDecoration({super.key, required this.waitTime});

  final Duration waitTime;

  BoxDecoration _getTimerBoxDecoration() {
    var gradientColor = Config.getGradientColor(waitTime.inMinutes);
    if (Config.darkModeOn) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColor.last.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
        borderRadius: Config.borderRadiusLarge,
      );
    }
    return BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: Config.borderRadiusLarge
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getTimerBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimerButton(
              onPressed: () {},
              icon: Icon(
                Icons.play_arrow,
                color: Config.iconColor,
                size: iconSize,
              )
          ),
          _buildTimerLabel(),
          _buildTimerButton(
              onPressed: () {},
              icon: Icon(
                Icons.replay,
                color: Config.iconColor,
                size: iconSize,
              )
          )
        ],
      ),
    );
  }

  double get iconSize => 24;

  Widget _buildTimerButton(
      {required void Function() onPressed, required Icon icon}) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      child: IconButton(
          onPressed: onPressed,
          iconSize: iconSize,
          icon: icon),
    );
  }

  Color _getDigitsColor() {
    if (Config.darkModeOn) {
      return Colors.white;
    }
    return Colors.black87;
  }

  Widget _buildTimerLabel() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(waitTime.inHours.remainder(24));
    final minutes = strDigits(waitTime.inMinutes.remainder(60));
    final seconds = strDigits(waitTime.inSeconds.remainder(60));
    return Text(
      waitTime.inHours == 0
          ? "$minutes:$seconds"
          : "$hours:$minutes:$seconds",
      style: TextStyle(
        fontFamily: Config.fontFamily,
        fontSize: 22,
        color: _getDigitsColor(),
      ),
    );
  }
}
