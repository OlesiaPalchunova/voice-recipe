import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';


class InputLabel extends StatefulWidget {
  const InputLabel(
      {key,
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
  final Function(String, List<String>)? onChanged;
  final double fontSize;

  @override
  State<InputLabel> createState() => _InputLabelState();
}

class _InputLabelState extends State<InputLabel> {

  bool get verticalExpand => widget.verticalExpand;
  VoidCallback? get onSubmit => widget.onSubmit;
  VoidCallback? get onTap => widget.onTap;
  Function(String, List<String>)? get onChanged => widget.onChanged;

  InputDecoration buildInputDecoration(
          {required String labelText,
          Widget? suffixIcon,
          Widget? prefixIcon,
          String? hintText,
          bool? withContentPadding}) {
    bool withPadding = false;
    if (withContentPadding != null) {
      withPadding = withContentPadding;
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
        fillColor: Config.darkModeOn ? Colors.grey.shade900 : Colors.white,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: (error[0] != "") ? error[0] : null,
        errorStyle: TextStyle(height: 9),
    );
  }

  List<String> error = [""];

  void _onChanged (String input){
    List<String> output = [""];
    if (onChanged != null) onChanged!(input, output);
    setState(() {
      error[0] = output[0];
    });
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
              onChanged: _onChanged,
              focusNode: widget.focusNode,
              controller: widget.controller,
              decoration: buildInputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  withContentPadding: widget.withContentPadding,

              ),
              style: TextStyle(
                  color: Config.iconColor.withOpacity(0.8),
                  fontSize: widget.fontSize,
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
              onChanged: _onChanged,
              focusNode: widget.focusNode,
              controller: widget.controller,
              decoration: buildInputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  withContentPadding: widget.withContentPadding),
              style: TextStyle(
                  color: Config.iconColor.withOpacity(0.8),
                  fontSize: widget.fontSize,
                  fontFamily: Config.fontFamily),
            ),
          );
  }
}
