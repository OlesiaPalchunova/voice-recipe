import 'package:flutter/material.dart';
import 'package:voice_recipe/components/buttons/classic_button.dart';
import 'package:voice_recipe/components/labels/input_label.dart';
import 'package:voice_recipe/services/auth/auth.dart';
import 'package:voice_recipe/pages/account/login_page.dart';

import '../../config/config.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({key});

  static const route = '/login/reset-password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String get email => _emailController.text.trim();

  @override
  Widget build(BuildContext context) {
    var width = Config.loginPageWidth(context);
    return Scaffold(
      appBar: Config.defaultAppBar,
      body: GestureDetector(
        onTap: () => _emailFocusNode.unfocus(),
        child: Container(
          color: Config.backgroundEdgeColor,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: width,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(Config.margin),
              padding: const EdgeInsets.all(Config.margin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Config.pageHeight(context) / 3,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/voice_recipe.png"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Config.padding).add(
                        const EdgeInsets.symmetric(horizontal: Config.padding)),
                    width: width * .85,
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
                  LoginPage.inputWrapper(
                      InputLabel(
                          onSubmit: () => AuthenticationManager()
                              .passwordReset(context, email),
                          focusNode: _emailFocusNode,
                          labelText: "Email",
                          controller: _emailController),
                      context),
                  const SizedBox(
                    height: Config.margin,
                  ),
                  SizedBox(
                      height: 60,
                      width: width * 0.8,
                      child: ClassicButton(
                        onTap: () => AuthenticationManager()
                            .passwordReset(context, email),
                        text: "Сменить пароль",
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
