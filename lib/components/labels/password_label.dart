import 'package:flutter/material.dart';
import 'package:voice_recipe/components/labels/input_label.dart';

import '../../config/config.dart';

class PasswordLabel extends StatelessWidget {
  const PasswordLabel(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.onSubmit,
      this.focusNode});

  final String hintText;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Config.isDesktop(context) ? 60 : 40,
      child: TextFormField(
              onFieldSubmitted: (s) {
                onSubmit();
              },
              obscureText: true,
              focusNode: focusNode,
              obscuringCharacter: '*',
              controller: controller,
              decoration: InputLabel.buildInputDecoration(
                  labelText: hintText,
              ),
              style: TextStyle(
                  color: Config.iconColor.withOpacity(0.8),
                  fontSize: 18,
                  fontFamily: Config.fontFamily),

      ),
    );
  }
}
