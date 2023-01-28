import 'package:flutter/material.dart';
import 'package:voice_recipe/services/auth/auth.dart';
import 'package:voice_recipe/components/utils/animated_loading.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/buttons/classic_button.dart';
import '../../components/buttons/login/sign_in_button.dart';
import '../../components/labels/input_label.dart';
import '../../components/labels/password_label.dart';
import '../../config/config.dart';
import 'package:voice_recipe/pages/account/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const route = '/login/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    return Scaffold(
      appBar: Config.defaultAppBar,
      backgroundColor: Config.backgroundEdgeColor,
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
                      LoginPage.voiceRecipeIcon(
                          context,
                          Config.loginPageHeight(context) / 4,
                          Config.loginPageHeight(context) / 6
                      ),
                      SizedBox(
                        // height: Config.loginPageHeight(context) * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoginPage.inputWrapper(
                                InputLabel(
                                    focusNode: _firstNameFocusNode,
                                    labelText: "Имя",
                                    controller: _firstNameController),
                                context),
                            LoginPage.inputWrapper(
                                InputLabel(
                                    focusNode: _secondNameFocusNode,
                                    labelText: "Фамилия",
                                    controller: _secondNameController),
                                context),
                            LoginPage.inputWrapper(
                                InputLabel(
                                  focusNode: _emailFocusNode,
                                  labelText: 'Email',
                                  controller: _emailController,
                                ),
                                context),
                            LoginPage.inputWrapper(
                                PasswordLabel(
                                  focusNode: _passwordFocusNode,
                                  hintText: "Пароль",
                                  controller: _passwordController,
                                  onSubmit: () {},
                                ),
                                context),
                            LoginPage.inputWrapper(
                                PasswordLabel(
                                  focusNode: _confirmPasswordFocusNode,
                                  hintText: "Подтвердите пароль",
                                  controller: _confirmPasswordController,
                                  onSubmit: () => register(Method.email),
                                ),
                                context),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: Config.margin),
                              height: Config.loginPageHeight(context) / 12,
                              width: LoginPage.buttonWidth(context),
                              child: ClassicButton(
                                onTap: () => register(Method.email),
                                text: "Создать аккаунт",
                                customBorderColor: Colors.black54,
                              ),
                            ),
                            Container(
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
                                      onPressed: () => register(Method.google)
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

  void register(Method method) async {
    AnimatedLoading().execute(
      context,
      task: () async {
        bool logged = false;
        if (method == Method.email) {
          logged = await AuthenticationManager().signUp(
              context,
              email,
              password,
              confirmPassword,
              firstName,
              secondName);
        } else {
          logged = await AuthenticationManager().signInWithGoogle(context);
        }
        return logged;
      },
      onSuccess: () => Navigator.of(context).pop()
    );
  }
}
