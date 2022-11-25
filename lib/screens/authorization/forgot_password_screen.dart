import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/components/appbars/title_logo_panel.dart';
import 'package:voice_recipe/components/login/button.dart';
import 'package:voice_recipe/components/login/input_label.dart';

import '../../config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String get email => _emailController.text.trim();

  void showAlertDialog(String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Config.backgroundColor,
          content: Text(
            text,
            style: TextStyle(
                color: Config.iconColor,
                fontFamily: Config.fontFamily,
                fontSize: 20
            ),
          ),
        )
    );
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email
      );
      showAlertDialog("Подтверждение отправлено вам на почту.");
    } on FirebaseException catch(e) {
      showAlertDialog(e.message?? "Возникла ошибка");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = min(Config.slideWidth(context), 500.0);
    return Scaffold(
      appBar: const TitleLogoPanel(
        title: "Voice Recipe",
      ).appBar(),
      body: GestureDetector(
        onTap: () => _emailFocusNode.unfocus(),
        child: Container(
          color: Config.backgroundColor,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(Config.margin),
            padding: const EdgeInsets.all(Config.margin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(Config.padding).add(
                      const EdgeInsets.symmetric(horizontal: Config.padding)),
                  alignment: Alignment.center,
                  child: Text(
                      "Введите свой email, чтобы мы прислали вам"
                      " письмо с инструкцией по смене пароля.",
                      style: TextStyle(
                          color: Config.iconColor,
                          fontFamily: Config.fontFamily,
                          fontSize: 20)),
                ),
                const SizedBox(
                  height: Config.margin,
                ),
                InputLabel(
                    focusNode: _emailFocusNode,
                    hintText: "Email",
                    width: width * 0.8,
                    controller: _emailController),
                const SizedBox(
                  height: Config.margin,
                ),
                SizedBox(
                    height: 60,
                    child: Button(
                      onTap: passwordReset,
                      text: "Сменить пароль",
                      width: width * 0.8,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
