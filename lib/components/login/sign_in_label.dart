import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignInLabel extends StatelessWidget {
  const SignInLabel({
    super.key,
    required this.button,
    required this.onPressed,
    this.height = 30,
    this.width = 150
  });

  final VoidCallback onPressed;
  final Buttons button;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 10, right: 5),
        child: SignInButton(
          button,
          text: "Sign in",
          onPressed: onPressed,
        ),
      ),
    );
  }
}
