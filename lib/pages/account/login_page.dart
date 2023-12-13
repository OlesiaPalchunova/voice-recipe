import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_recipe/services/auth/auth.dart';
import 'package:voice_recipe/pages/account/forgot_password_page.dart';
import 'package:voice_recipe/pages/account/register_page.dart';
import 'package:voice_recipe/components/utils/animated_loading.dart';

import '../../api/api_fields.dart';
import '../../components/buttons/classic_button.dart';
import '../../components/labels/input_label.dart';
import '../../components/labels/password_label.dart';
import '../../components/buttons/login/ref_button.dart';
import '../../components/buttons/login/sign_in_button.dart';
import '../../config/config.dart';

import 'package:voice_recipe/services/service_io.dart';

import 'package:http/http.dart' as http;

import '../../services/BannerAdPage.dart';
import '../../services/auth/Token.dart';
import '../../services/auth/authorization.dart';

enum Method {
  nickname, google, email
}

class LoginPage extends StatefulWidget {
  const LoginPage({key});

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
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get nickname => _nicknameController.text.trim();

  String get password => _passwordController.text.trim();



  @override
  dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Config.iconColor;
    return Scaffold(
      appBar: Config.defaultAppBar,
      backgroundColor: Config.backgroundEdgeColor,
      bottomNavigationBar: BottomBannerAd(),
      body: GestureDetector(
        onTap: () {
          _nicknameFocusNode.unfocus();
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
                                  focusNode: _nicknameFocusNode,
                                  labelText: 'Логин',
                                  controller: _nicknameController,
                                  onSubmit: () => login(Method.nickname),
                                ),
                                context),
                            LoginPage.inputWrapper(
                                PasswordLabel(
                                  focusNode: _passwordFocusNode,
                                  hintText: "Пароль",
                                  controller: _passwordController,
                                  onSubmit: () => login(Method.nickname),
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
                                  onTap: () => login(Method.nickname),
                                  text: "Войти",
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

//   late SharedPreferences prefs;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initSharedPref();
//   }
//
//   void initSharedPref() async{
//     prefs = await SharedPreferences.getInstance();
//     ServiceIO.setToken();
//   }
//
//   // Сохранение токена доступа
//   Future<void> saveAccessToken(String token) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('accessToken', token);
//   }
//
// // Извлечение токена доступа
//   Future<String?> getAccessToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accessToken');
//   }

  void loginUser() async{
    if (_nicknameController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      var reqBody = {
        "login":_nicknameController.text,
        "password":_passwordController.text,
      };

      var response = await http.post(Uri.parse('${apiUrl}login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody)
      );

      var jsonResponse = jsonDecode(response.body);

      print("666666666666666666");
      print(response.statusCode);

      if (response.statusCode == 200) {
        var accessToken = jsonResponse["accessToken"];
        print(jsonResponse["accessToken"]);
        // print(jsonResponse["refreshToken"]);
        Token.setAccessToken(accessToken);
      } else {
        print("555555555555555555");
      }

    }
  }

  void login(Method method) async {
    AnimatedLoading().execute(
      context,
      task: () async {
        Authorization.loginUser(_nicknameController.text, _passwordController.text);
        // Authorization.refreshTokens();
        return true;
        // bool logged = false;
        // if (method == Method.nickname) {
        //   logged = await AuthenticationManager()
        //       .signIn(context, nickname, password);
        // } else {
        //   logged = await AuthenticationManager()
        //       .signInWithGoogle(context);
        // }
        // return logged;
      },
      onSuccess: () => Routemaster.of(context).pop()
    );
  }

  void _onForgotPassword(BuildContext context) {
    Routemaster.of(context).push(ForgotPasswordPage.route);
  }
}
