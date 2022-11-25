import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../components/appbars/title_logo_panel.dart';
import '../components/login/button.dart';
import '../components/login/input_label.dart';
import '../components/login/password_label.dart';
import '../components/login/sign_in_label.dart';
import '../config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const height = 800;
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future signUp() async {
    if (!isPasswordConfirmed()) {
      return;
    }
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
    );
    await Future.microtask(() => Navigator.of(context).pop());
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isPasswordConfirmed() {
    return _passwordController.text.trim() == _confirmPasswordController
        .text.trim();
  }

  @override
  Widget build(BuildContext context) {
    var width = min(Config.slideWidth(context), 500.0);
    Color backColor = Config.lastBackColor;
    Color textColor = Config.iconColor;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Config.iconColor,
        backgroundColor: Config.backgroundColor,
        title: const TitleLogoPanel(
          title: "Voice Recipe",
        ),
      ),
      backgroundColor: backColor,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: width,
            child: Column(
              children: [
                _buildIcon(),
                SizedBox(
                  height: height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputLabel(
                          hintText: "Логин",
                          width: width * 0.8,
                          controller: _loginController
                      ),
                      InputLabel(
                        width: width * 0.8,
                        hintText: 'Email',
                        controller: _emailController,
                      ),
                      PasswordLabel(
                        width: width * 0.8,
                        hintText: "Пароль",
                        controller: _passwordController,
                        onSubmit: () {},
                      ),
                      PasswordLabel(
                        width: width * 0.8,
                        hintText: "Подтвердите пароль",
                        controller: _confirmPasswordController,
                        onSubmit: signUp,
                      ),
                      SizedBox(
                        height: height * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 20, bottom: 20),
                          child: Button(onTap: signUp,
                          width: width * 0.8, text: "Создать аккаунт",),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SignInLabel(
                              button: Buttons.AppleDark,
                              onPressed: () {},
                              width: width / 3.5,
                            ),
                            SignInLabel(
                              button: Buttons.Google,
                              onPressed: () {},
                              width: width / 3.5,
                            ),
                            SignInLabel(
                              button: Buttons.Facebook,
                              onPressed: () {},
                              width: width / 3.5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      height: height * 0.25,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }
}
