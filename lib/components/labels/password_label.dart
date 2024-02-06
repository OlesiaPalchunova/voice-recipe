import 'package:flutter/material.dart';
import 'package:voice_recipe/components/labels/input_label.dart';

import '../../config/config.dart';

class PasswordLabel extends StatefulWidget {
  const PasswordLabel(
      {key,
        required this.hintText,
        required this.controller,
        required this.onSubmit,
        this.focusNode});

  final String hintText;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final FocusNode? focusNode;

  @override
  State<PasswordLabel> createState() => _PasswordLabelState();
}

class _PasswordLabelState extends State<PasswordLabel> {
  String get hintText => widget.hintText;
  TextEditingController get controller => widget.controller;
  VoidCallback get onSubmit => widget.onSubmit;
  FocusNode? get focusNode => widget.focusNode;

  String error = "";

  InputDecoration buildInputDecoration(
      {required String labelText,
        Widget? suffixIcon,
        Widget? prefixIcon,
        String? hintText,
        bool? withContentPadding}) {
    bool withPadding = false;
    if (withContentPadding != null) {
      withPadding = withContentPadding;
    }
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      contentPadding: withPadding
          ? null
          : const EdgeInsets.symmetric(horizontal: Config.margin),
      labelStyle: TextStyle(
          color: Config.iconColor.withOpacity(0.7),
          fontFamily: Config.fontFamily),
      hintStyle: TextStyle(
        color: Config.iconColor.withOpacity(0.7),
        fontFamily: Config.fontFamily,
      ),
      floatingLabelAlignment: FloatingLabelAlignment.start,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: .2, color: Colors.transparent),
          borderRadius: Config.borderRadiusLarge),
      focusedBorder: OutlineInputBorder(
          borderRadius: Config.borderRadiusLarge,
          borderSide: BorderSide(
              color: Config.darkModeOn
                  ? Colors.orangeAccent
                  : Colors.black54)),
      hoverColor: !Config.darkModeOn
          ? Colors.orangeAccent.withOpacity(.2)
          : Colors.grey.shade800,
      fillColor: Config.darkModeOn ? Colors.grey.shade900 : Colors.white,
      filled: true,
      helperText: '',
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: (error != "") ? error : null,
      alignLabelWithHint: true,
      // errorStyle: TextStyle(height: 0.5),
    );
  }

  void onChangePassword(String password) {
    String _error = "";
    int digitCount = 0;
    for (int i = 0; i < password.length; i++) {
      if (password[i].contains(RegExp(r'[0-9]'))) {
        digitCount++;
      }
    }
    if (password.length < 4) _error = "Пароль слишком короткий";
    else if (password.length > 32) _error = "Пароль слишком длинный";
    else if (digitCount == 0) _error = "Введите цифры";
    else if (digitCount == password.length) _error = "Введите другие символы";
    else _error = "";

    setState(() {
      error = _error;
    });
  }

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
              onChanged: onChangePassword,
              decoration: buildInputDecoration(
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
