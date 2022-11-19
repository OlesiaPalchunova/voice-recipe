import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../components/appbars/title_logo_panel.dart';
import '../components/login/input_label.dart';
import '../components/login/sign_in_label.dart';
import '../config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const height = 700;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
    );
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Еще нет аккаунта?',
                            style: TextStyle(
                                color: textColor.withOpacity(0.8),
                                fontSize: 18,
                                fontFamily: Config.fontFamily),
                          ),
                          const SizedBox(
                            width: Config.padding,
                          ),
                          Text(
                            'Создать',
                            style: TextStyle(
                                color: textColor.withOpacity(0.8),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: Config.fontFamilyBold),
                          )
                        ],
                      ),
                      InputLabel(
                        width: width * 0.8,
                        hintText: 'Email',
                        controller: _emailController,
                      ),
                      InputLabel(
                        width: width * 0.8,
                        hintText: "Password",
                        controller: _passwordController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Забыли пароль?',
                          style: TextStyle(
                              color: textColor.withOpacity(0.8),
                              fontSize: 18,
                              fontFamily: Config.fontFamily),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.15,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 30, bottom: 20),
                          child: InkWell(
                            onTap: signIn,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Config.borderRadius),
                              child: Container(
                                width: width * 0.8,
                                color: Colors.black87,
                                child: const Center(
                                  child: Text('Войти',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: Config.fontFamily)),
                                ),
                              ),
                            ),
                          ),
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
                              width: width / 4,
                            ),
                            SignInLabel(
                              button: Buttons.Google,
                              onPressed: () {},
                              width: width / 4,
                            ),
                            SignInLabel(
                              button: Buttons.Facebook,
                              onPressed: () {},
                              width: width / 4,
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
      height: height * 0.35,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }
}
