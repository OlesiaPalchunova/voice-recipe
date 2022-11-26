import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:voice_recipe/screens/authorization/forgot_password_screen.dart';
import 'package:voice_recipe/screens/authorization/register_screen.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/login/button.dart';
import '../../components/login/input_label.dart';
import '../../components/login/password_label.dart';
import '../../components/login/ref_button.dart';
import '../../components/login/sign_in_label.dart';
import '../../config.dart';
import '../../model/users_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const height = 700;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  static int counter = 3;
  final vk = VKLogin();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    await Future.microtask(() {
      users.add(
          UserAccountInfo(id: counter++, name: _emailController.text.trim()));
    });
    await Future.microtask(() => Navigator.of(context).pop());
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
      body: GestureDetector(
        onTap: () {
          _emailFocusNode.unfocus();
          _passwordFocusNode.unfocus();
        },
        child: SingleChildScrollView(
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
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen())),
                              child: Text(
                                'Создать',
                                style: TextStyle(
                                    color: textColor.withOpacity(0.8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Config.fontFamilyBold),
                              ),
                            )
                          ],
                        ),
                        InputLabel(
                          focusNode: _emailFocusNode,
                          width: width * 0.8,
                          hintText: 'Email',
                          controller: _emailController,
                        ),
                        PasswordLabel(
                          focusNode: _passwordFocusNode,
                          width: width * 0.8,
                          hintText: "Пароль",
                          controller: _passwordController,
                          onSubmit: signIn,
                        ),
                        RefButton(
                          text: "Забыли пароль?",
                          onTap: () => _onForgotPassword(context),
                        ),
                        SizedBox(
                          height: height * 0.15,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 20, bottom: 20),
                              child: Button(
                                onTap: signIn,
                                text: "Войти",
                                width: width * 0.8,
                              )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                onPressed: signInVK,
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
      ),
    );
  }

  void signInVK() async {
    if (!vk.isInitialized) {
      var initialized = await vk.initSdk();
      if (initialized.isError) {
        debugPrint(initialized.asError!.error.toString());
        return;
      }
    }
    final res = await vk.logIn(scope: [
      VKScope.email,
    ]);
    if (res.isError) {
      final errorRes = res.asError;
      debugPrint(errorRes!.error.toString());
      return;
    }
    final VKLoginResult data = res.asValue!.value;
    if (data.isCanceled) {
      return;
    }
    // final VKAccessToken accessToken = data.accessToken!;
    var profile = await vk.getUserProfile();
    debugPrint('Your name is ${profile.asValue!.value!.firstName}');
    debugPrint('Your user id is ${profile.asValue!.value!.userId}');
    debugPrint('Your photo is ${profile.asValue!.value!.photo200}');
  }

  void _onForgotPassword(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
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
