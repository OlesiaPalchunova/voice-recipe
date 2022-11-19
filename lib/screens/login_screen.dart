import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    var width = min(Config.slideWidth(context), 500.0);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Config.iconColor,
        backgroundColor: Config.backgroundColor,
        title: const TitleLogoPanel(
          title: "Voice Recipe",
        ),
      ),
      backgroundColor: Colors.brown[100],
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
                        children: const [
                          Text(
                            'Еще нет аккаунта?',
                            style: TextStyle(
                                color: Colors.brown,
                                fontSize: 20,
                                fontFamily: Config.fontFamily),
                          ),
                          SizedBox(width: Config.padding,),
                          Text(
                            'Создать',
                            style: TextStyle(
                                color: Colors.brown,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: Config.fontFamilyBold),
                          )
                        ],
                      ),
                      const InputLabel(
                        hintText: 'email@example.com',
                        iconData: Icons.accessibility,
                      ),
                      const InputLabel(
                          hintText: "пароль",
                          iconData: Icons.lock
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Забыли пароль?',
                          style: TextStyle(
                              color: Colors.brown,
                              fontSize: 20,
                              fontFamily: Config.fontFamily
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: Colors.brown,
                              child: const Center(
                                child: Text('Войти',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: Config.fontFamily
                                    )
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
      height: height * 0.4,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }
}
