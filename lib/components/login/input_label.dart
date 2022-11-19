import 'package:flutter/material.dart';

import '../../config.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    required this.hintText,
    required this.width,
    required this.controller,
    this.height = 70
  });

  final String hintText;
  final double height;
  final double width;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Config.borderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: Config.padding,),
              SizedBox(
                width: width,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Config.iconColor,
                        fontFamily: Config.fontFamily),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Config.borderRadius),
                      // borderSide: BorderSide(
                      //     color: Config.iconColor,
                      //     width: 0.8
                      // ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Config.borderRadius),
                      borderSide: BorderSide(color: Config.iconColor,
                          width: 0.8),
                    ),
                    fillColor: Config.darkModeOn ? Config.pressed.withOpacity(0.9)
                        : Colors.white,
                    filled: true
                  ),
                  style: TextStyle(
                      color: Config.iconColor.withOpacity(0.8), fontSize: 18,
                      fontFamily: Config.fontFamily),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
