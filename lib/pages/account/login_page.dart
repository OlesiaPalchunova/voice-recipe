import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:voice_recipe/model/auth/auth.dart';
import 'package:voice_recipe/pages/account/forgot_password_page.dart';
import 'package:voice_recipe/pages/account/register_page.dart';
import 'package:voice_recipe/components/utils/animated_loading.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/buttons/classic_button.dart';
import '../../components/labels/input_label.dart';
import '../../components/labels/password_label.dart';
import '../../components/buttons/login/ref_button.dart';
import '../../components/buttons/login/sign_in_button.dart';
import '../../config.dart';

enum Method {
  email, google
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const route = '/login';

  static const fontSize = 18.0;

  static double buttonWidth(BuildContext context) =>
      Config.loginPageWidth(context) * 0.8;

  static double labelHeight(BuildContext context) =>
      Config.loginPageHeight(context) / 13;

  @override
  State<LoginPage> createState() => _LoginPageState();

  static Widget voiceRecipeIcon(
      BuildContext context, double height, double iconSize) {
    return SizedBox(
      height: height,
      child: SizedBox(
        height: iconSize,
        width: iconSize,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }

  static SizedBox inputWrapper(Widget child, BuildContext context) {
    return SizedBox(
      height: labelHeight(context),
      width: buttonWidth(context),
      child: child,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Config.iconColor;
    return Scaffold(
      appBar: Config.defaultAppBar,
      backgroundColor: Config.backgroundEdgeColor,
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
                      LoginPage.voiceRecipeIcon(
                          context,
                          Config.loginPageHeight(context) / 3,
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
                                      fontSize: LoginPage.fontSize,
                                      fontFamily: Config.fontFamily),
                                ),
                                const SizedBox(
                                  width: Config.padding,
                                ),
                                InkWell(
                                  onTap: () => Routemaster.of(context)
                                      .push(RegisterPage.route),
                                  child: Text(
                                    'Создать',
                                    style: TextStyle(
                                        color: textColor.withOpacity(0.8),
                                        fontSize: LoginPage.fontSize,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Config.fontFamilyBold),
                                  ),
                                )
                              ],
                            ),
                            LoginPage.inputWrapper(
                                InputLabel(
                                  focusNode: _emailFocusNode,
                                  labelText: 'Email',
                                  controller: _emailController,
                                  onSubmit: () => login(Method.email),
                                ),
                                context),
                            LoginPage.inputWrapper(
                                PasswordLabel(
                                  focusNode: _passwordFocusNode,
                                  hintText: "Пароль",
                                  controller: _passwordController,
                                  onSubmit: () => login(Method.email),
                                ),
                                context),
                            RefButton(
                              text: "Забыли пароль?",
                              onTap: () => _onForgotPassword(context),
                            ),
                            SizedBox(
                                height: Config.loginPageHeight(context) / 12,
                                width: LoginPage.buttonWidth(context),
                                child: ClassicButton(
                                  onTap: () => login(Method.email),
                                  text: "Войти",
                                  customBorderColor: Colors.black54,
                                )),
                            Container(
                              margin: const EdgeInsets.only(top: Config.margin),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  SignInButton(
                                      width: LoginPage.buttonWidth(context),
                                      backgroundColor:
                                      Config.darkModeOn ? const Color(0xff202020) : Colors.white,
                                      textColor: Config.darkModeOn ? Colors.white : Colors.black,
                                      text: "Войти через Google",
                                      imageURL: "assets/images/icons/google.png",
                                      onPressed: () => login(Method.google),
                                  )
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
            )
      ),
    );
  }

  void login(Method method) async {
    AnimatedLoading().execute(
      context,
      task: () async {
        bool logged = false;
        if (method == Method.email) {
          logged = await AuthenticationManager()
              .signIn(context, email, password);
        } else {
          logged = await AuthenticationManager()
              .signInWithGoogle(context);
        }
        return logged;
      },
      onSuccess: () => Routemaster.of(context).pop()
    );
  }

  void _onForgotPassword(BuildContext context) {
    Routemaster.of(context).push(ForgotPasswordPage.route);
  }
}
