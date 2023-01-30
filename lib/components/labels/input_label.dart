import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

class InputLabel extends StatelessWidget {
  const InputLabel(
      {super.key,
      required this.labelText,
      required this.controller,
      this.focusNode,
      this.onSubmit,
      this.onTap,
      this.onChanged,
      this.hintText,
      this.prefixIcon,
      this.fontSize = 18,
      this.verticalExpand = false,
      this.withContentPadding = false});

  final bool verticalExpand;
  final bool withContentPadding;
  final String? hintText;
  final String labelText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onSubmit;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final double fontSize;

  static InputDecoration buildInputDecoration(
          {required String labelText,
          Widget? suffixIcon,
          Widget? prefixIcon,
          String? hintText,
          bool? withContentPadding}) {
    bool withPadding = false;
    if (withContentPadding != null) {
      withPadding = withContentPadding!;
    }
    return InputDecoration(
        hintText: hintText,
        labelText: labelText,
        contentPadding: withPadding
            ? null
            : const EdgeInsets.symmetric(horizontal: Config.margin),
        labelStyle: TextStyle(
            color: Config.iconColor.withOpacity(0.7),
            fontFamily: Config.fontFamily),
        hintStyle: TextStyle(
          color: Config.iconColor.withOpacity(0.7),
          fontFamily: Config.fontFamily,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .2, color: Colors.transparent),
            borderRadius: Config.borderRadiusLarge),
        focusedBorder: OutlineInputBorder(
            borderRadius: Config.borderRadiusLarge,
            borderSide: BorderSide(
                color: Config.darkModeOn
                    ? Colors.orangeAccent
                    : Colors.black54)),
        hoverColor: !Config.darkModeOn
            ? Colors.orangeAccent.withOpacity(.2)
            : Colors.grey.shade800,
        fillColor: Config.darkModeOn ? Colors.white12 : Colors.white70,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon);
  }

  @override
  Widget build(BuildContext context) {
    return verticalExpand
        ? SizedBox(
            // height: Config.isDesktop(context) ? 60 : 40,
            child: TextField(
              onSubmitted: (s) {
                if (onSubmit == null) return;
                onSubmit!();
              },
              maxLines: null,
              onTap: onTap,
              onChanged: onChanged,
              focusNode: focusNode,
              controller: controller,
              decoration: buildInputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                  withContentPadding: withContentPadding),
              style: TextStyle(
                  color: Config.iconColor.withOpacity(0.8),
                  fontSize: fontSize,
                  fontFamily: Config.fontFamily
              ),
            ),
          )
        : SizedBox(
            // height: Config.isDesktop(context) ? 60 : 40,
            child: TextFormField(
              onFieldSubmitted: (s) {
                if (onSubmit == null) return;
                onSubmit!();
              },
              onTap: onTap,
              onChanged: onChanged,
              focusNode: focusNode,
              controller: controller,
              decoration: buildInputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  prefixIcon: prefixIcon,
                  withContentPadding: withContentPadding),
              style: TextStyle(
                  color: Config.iconColor.withOpacity(0.8),
                  fontSize: fontSize,
                  fontFamily: Config.fontFamily),
            ),
          );
  }
}
