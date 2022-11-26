import 'package:flutter/material.dart';

import '../../config.dart';

class SignInButton extends StatefulWidget {
  const SignInButton(
      {super.key,
      required this.text,
      required this.imageURL,
      required this.onPressed,
      required this.backgroundColor,
        required this.textColor,
      this.height = 40,
      this.width = 150
      });

  final VoidCallback onPressed;
  final double height;
  final double width;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final String imageURL;

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  var hovered = false;
  var pressed = false;

  Color get backgroundColor => hovered | pressed
      ? widget.backgroundColor//.withOpacity(0.8)
      : widget.backgroundColor;

  List<BoxShadow> get shadow => !hovered & !pressed
      ? []
      : const [BoxShadow(color: Colors.orangeAccent, blurRadius: 6)];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (h) => setState(() {
        hovered = h;
      }),
      onTap: () async {
        setState(() {
          pressed = true;
        });
        await Future.delayed(Config.shortAnimationTime).whenComplete(() {
          setState(() {
            pressed = false;
          });
        });
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: Config.shortAnimationTime,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
          color: backgroundColor,
          border: Border.all(
            color: Colors.black87,
            width: 0.1
          ),
          boxShadow: shadow
        ),
        alignment: Alignment.center,
        height: widget.height,
        width: widget.width,
        margin: const EdgeInsets.symmetric(vertical: Config.margin / 2),
        padding: const EdgeInsets.symmetric(horizontal: Config.padding * 2),
        child: Row(
          children: [
            Image.asset(widget.imageURL),
            const SizedBox(width: Config.margin,),
            Text(widget.text, style: TextStyle(
              color: widget.textColor,
              fontFamily: Config.fontFamily,
              fontSize: 18
            ),)
          ],
        ),
      ),
    );
  }
}
