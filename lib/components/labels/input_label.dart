import 'package:flutter/material.dart';

import '../../config.dart';

class InputLabel extends StatelessWidget {
  const InputLabel(
      {super.key,
      required this.labelText,
      required this.controller,
      this.focusNode,
      this.onSubmit,
        this.hintText,
      this.fontSize = 18});

  final String? hintText;
  final String labelText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onSubmit;
  final double fontSize;

  static InputDecoration buildInputDecoration(
          {required String labelText, Widget? suffixIcon, String? hintText}) =>
      InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(
              color: Config.iconColor.withOpacity(0.7),
              fontFamily: Config.fontFamily
          ),
          hintStyle: TextStyle(
              color: Config.iconColor.withOpacity(0.7),
              fontFamily: Config.fontFamily,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.2, color: Colors.black87),
              borderRadius: Config.borderRadiusLarge
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: Config.borderRadiusLarge,
              borderSide: BorderSide(
                  color: Config.darkModeOn ? Colors.orangeAccent : Colors.black54)
          ),
          hoverColor: !Config.darkModeOn ? Colors.orangeAccent.withOpacity(.1) : Colors.grey.shade800,
          fillColor: Config.darkModeOn ? Colors.white12 : Colors.white70,
          filled: true,
          suffixIcon: suffixIcon
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            onFieldSubmitted: (s) {
              if (onSubmit == null) return;
              onSubmit!();
            },
            focusNode: focusNode,
            controller: controller,
            decoration: buildInputDecoration(
            labelText: labelText, hintText: hintText),
            style: TextStyle(
                color: Config.iconColor.withOpacity(0.8),
                fontSize: fontSize,
                fontFamily: Config.fontFamily
            ),
    );
  }
}
