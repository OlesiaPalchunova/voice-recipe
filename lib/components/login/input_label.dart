import 'package:flutter/material.dart';

import '../../config.dart';

class InputLabel extends StatelessWidget {
  const InputLabel(
      {super.key,
      required this.hintText,
      required this.width,
      required this.controller,
      this.height = 60});

  final String hintText;
  final double height;
  final double width;
  final TextEditingController controller;

  static InputDecoration buildInputDecoration(String hintText,
          [Widget? suffixIcon]) =>
      InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: Config.iconColor.withOpacity(0.7),
              fontFamily: Config.fontFamily),
          disabledBorder: const OutlineInputBorder(),
          fillColor: Config.backgroundColor.withOpacity(0.8),
          filled: true,
          suffixIcon: suffixIcon);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        // padding:
        //     const EdgeInsets.only(left: 40, right: 40, top: Config.padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Config.borderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: Config.padding,
              ),
              SizedBox(
                width: width * 0.9,
                child: TextField(
                  controller: controller,
                  decoration: buildInputDecoration(hintText),
                  style: TextStyle(
                      color: Config.iconColor.withOpacity(0.8),
                      fontSize: 18,
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
