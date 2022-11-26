import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/login/button.dart';
import '../../components/login/input_label.dart';
import '../../components/login/password_label.dart';
import '../../components/login/sign_in_label.dart';
import '../../config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const height = 800;
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

  Future signUp() async {
    if (!isPasswordConfirmed()) {
      Config.showAlertDialog("Пароли не совпадают", context);
      return;
    }
    try {
      String emailCurrent = email;
      String passCurrent = password;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailCurrent, password: passCurrent);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCurrent,
          password: passCurrent);
      var user = FirebaseAuth.instance.currentUser!;
      user.updateDisplayName("$firstName $secondName");
      await FirebaseAuth.instance.signOut();
      // await addUserDetails();
      await Future.microtask(() => Navigator.of(context).pop());
    } on FirebaseException catch(e) {
      Config.showAlertDialog(e.message!, context);
    }
  }

  Future addUserDetails() async {
    await FirebaseFirestore.instance.collection('users')
        .add({
      "first_name": firstName,
      "second_name": secondName,
      "image_ref": "",
      "email": email
    });
  }

  @override
  dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
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
    Color backColor = Config.lastBackColor?? Config.backgroundColor;
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
          _firstNameFocusNode.unfocus();
          _secondNameFocusNode.unfocus();
          _passwordFocusNode.unfocus();
          _confirmPasswordFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  _buildIcon(),
                  SizedBox(
                    height: height * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputLabel(
                          focusNode: _firstNameFocusNode,
                            hintText: "Имя",
                            width: width * 0.8,
                            controller: _firstNameController
                        ),
                        InputLabel(
                            focusNode: _secondNameFocusNode,
                            hintText: "Фамилия",
                            width: width * 0.8,
                            controller: _secondNameController
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
                          onSubmit: () {},
                        ),
                        PasswordLabel(
                          focusNode: _confirmPasswordFocusNode,
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
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      height: height * 0.2,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }
}
