import 'package:flutter/material.dart';
import 'package:voice_recipe/model/auth/auth.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/buttons/classic_button.dart';
import '../../components/labels/input_label.dart';
import '../../components/labels/password_label.dart';
import '../../config.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _secondNameFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  String get confirmPassword => _confirmPasswordController.text.trim();
  String get firstName => _firstNameController.text.trim();
  String get secondName => _secondNameController.text.trim();

  @override
  dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isPasswordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmPasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Config.backgroundColor;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Config.iconColor,
        backgroundColor: Config.backgroundColor,
        title: const TitleLogoPanel(
          title: Config.appName,
        ),
      ),
      backgroundColor: backColor,
      body: GestureDetector(
        onTap: () {
          _emailFocusNode.unfocus();
          _firstNameFocusNode.unfocus();
          _secondNameFocusNode.unfocus();
          _passwordFocusNode.unfocus();
          _confirmPasswordFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: Config.loginPageWidth(context),
              child: Column(
                children: [
                  LoginScreen.voiceRecipeIcon(
                      context,
                      Config.loginPageHeight(context) / 5,
                      Config.loginPageHeight(context) / 6),
                  SizedBox(
                    height: Config.loginPageHeight(context) * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginScreen.inputWrapper(
                            InputLabel(
                                focusNode: _firstNameFocusNode,
                                labelText: "Имя",
                                controller: _firstNameController),
                            context),
                        LoginScreen.inputWrapper(
                            InputLabel(
                                focusNode: _secondNameFocusNode,
                                labelText: "Фамилия",
                                controller: _secondNameController),
                            context),
                        LoginScreen.inputWrapper(
                            InputLabel(
                              focusNode: _emailFocusNode,
                              labelText: 'Email',
                              controller: _emailController,
                            ),
                            context),
                        LoginScreen.inputWrapper(
                            PasswordLabel(
                              focusNode: _passwordFocusNode,
                              hintText: "Пароль",
                              controller: _passwordController,
                              onSubmit: () {},
                            ),
                            context),
                        LoginScreen.inputWrapper(
                            PasswordLabel(
                              focusNode: _confirmPasswordFocusNode,
                              hintText: "Подтвердите пароль",
                              controller: _confirmPasswordController,
                              onSubmit: () => AuthenticationManager().signUp(
                                  context, email, password, confirmPassword, firstName, secondName),
                            ),
                            context),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: Config.margin),
                          height: Config.loginPageHeight(context) / 12,
                          width: LoginScreen.buttonWidth(context),
                          child: ClassicButton(
                            onTap: () => AuthenticationManager().signUp(
                                context, email, password, confirmPassword, firstName, secondName),
                            text: "Создать аккаунт",
                          ),
                        ),
                        Container(
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
}
