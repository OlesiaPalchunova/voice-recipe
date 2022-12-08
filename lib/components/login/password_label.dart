import 'package:flutter/material.dart';
import 'package:voice_recipe/components/login/input_label.dart';

import '../../config.dart';

class PasswordLabel extends StatefulWidget {
  const PasswordLabel({
    super.key,
    required this.hintText,
    required this.width,
    required this.controller,
    required this.onSubmit,
    this.height = 60,
    this.focusNode
  });

  final String hintText;
  final double height;
  final double width;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final FocusNode? focusNode;

  @override
  State<PasswordLabel> createState() => _PasswordLabelState();
}

class _PasswordLabelState extends State<PasswordLabel> {
  bool _obscureText = true;
  bool _hovered = false;
  static const double _disabledOpacity = 0.5;
  static const double _enabledOpacity = 0.7;

  double get opacity => _hovered ? _enabledOpacity : _disabledOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: Config.borderRadius,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.width,
              child: TextFormField(
                onFieldSubmitted: (s) {
                  widget.onSubmit();
                },
                focusNode: widget.focusNode,
                obscureText: _obscureText,
                obscuringCharacter: '*',
                controller: widget.controller,
                decoration: InputLabel.buildInputDecoration(widget.hintText,
                    InkWell(
                      onHover: (hover) {
                        setState(() {
                          _hovered = hover;
                        });
                      },
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Config.iconColor.withOpacity(opacity),
                      ),
                    )),
                style: TextStyle(
                    color: Config.iconColor.withOpacity(0.8),
                    fontSize: 18,
                    fontFamily: Config.fontFamily),
              ),
            )
          ],
        ),
      ),
    );
  }
}
