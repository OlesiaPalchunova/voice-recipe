import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_recipe/model/auth/vk.dart';
import 'package:voice_recipe/screens/authorization/forgot_password_screen.dart';
import 'package:voice_recipe/screens/authorization/register_screen.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/login/button.dart';
import '../../components/login/input_label.dart';
import '../../components/login/password_label.dart';
import '../../components/login/ref_button.dart';
import '../../components/login/sign_in_button.dart';
import '../../config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const fontSize = 18.0;
  static double buttonWidth(BuildContext context)
  => Config.loginPageWidth(context) * 0.8;
  static double labelHeight(BuildContext context)
  => Config.loginPageHeight(context) / 13;

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static Widget voiceRecipeIcon(BuildContext context, double height,
      double iconSize) {
    return SizedBox(
      height: height,
      child: SizedBox(
        height: iconSize,
        width: iconSize,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }

  static List<Widget> signInButtons(BuildContext context) {
    var res = [
      SignInButton(
          width: buttonWidth(context),
          backgroundColor: Config.darkModeOn ? const Color(0xff202020) : Colors.white,
          textColor: Config.darkModeOn ? Colors.white : Colors.black,
          text: "Войти через Google",
          imageURL: "assets/images/icons/google.png",
          onPressed: () {})
    ];
    if (!Config.isWeb) {
      res.add(SignInButton(
          width: buttonWidth(context),
          textColor: Colors.white,
          backgroundColor: const Color(0xff4680C2),
          text: "Войти через VK",
          imageURL: "assets/images/icons/vk.png",
          onPressed: () => Vk().signIn()));
    }
    return res;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  Future signIn() async {
    try {
      Config.showProgressCircle(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      await Future.microtask(() => Navigator.of(context).pop());
      await Future.microtask(() => Navigator.of(context).pop());
    } on FirebaseException catch (e) {
      Config.showAlertDialog(e.message!, context);
    }
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Config.lastBackColor ?? Config.backgroundColor;
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
          physics: const BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: Config.maxLoginPageWidth,
              child: Column(
                children: [
                  LoginScreen.voiceRecipeIcon(context, Config.loginPageHeight(context) / 3,
                  Config.loginPageHeight(context) / 6),
                  Container(
                    alignment: Alignment.center,
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
                                  fontSize: LoginScreen.fontSize,
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
                                    fontSize: LoginScreen.fontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Config.fontFamilyBold),
                              ),
                            )
                          ],
                        ),
                        InputLabel(
                          height: LoginScreen.labelHeight(context),
                          focusNode: _emailFocusNode,
                          width: LoginScreen.buttonWidth(context),
                          hintText: 'Email',
                          controller: _emailController,
                        ),
                        PasswordLabel(
                          height: LoginScreen.labelHeight(context),
                          focusNode: _passwordFocusNode,
                          width: LoginScreen.buttonWidth(context),
                          hintText: "Пароль",
                          controller: _passwordController,
                          onSubmit: signIn,
                        ),
                        RefButton(
                          text: "Забыли пароль?",
                          onTap: () => _onForgotPassword(context),
                        ),
                        SizedBox(
                            height: Config.loginPageHeight(context) / 12,
                            child: Button(
                              onTap: signIn,
                              text: "Войти",
                              width: LoginScreen.buttonWidth(context),
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: Config.margin),
                          alignment: Alignment.center,
                          child: Column(
                            children: LoginScreen.signInButtons(context),
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

  void signInVK() {
    Vk().signIn();
  }

  void _onForgotPassword(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
  }
}
