import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';
import 'classic_button.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key, required this.onTap, required this.text});

  final VoidCallback onTap;
  final String text;

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _disposed = false;

  Color get color => !_hovered & !_pressed
      ? ClassicButton.color
      : !Config.darkModeOn ? Colors.orangeAccent.withOpacity(.2)
      : Colors.grey.shade800;
  

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Config.isDesktop(context) ? 20 : 20,
      child: InkWell(
        onHover: (h) => setState(() => _hovered = h),
        borderRadius: Config.borderRadiusLarge,
        onTap: () {
          setState(() {
            _pressed = true;
          });
          Future.delayed(Config.animationTime, () {
            if (_disposed) return;
            setState(() {
              _pressed = false;
              widget.onTap();
            });
          });
        },
        child: AnimatedContainer(
          duration: Config.shortAnimationTime,
          decoration: BoxDecoration(
              color: color,
              borderRadius: Config.borderRadiusLarge),
          padding: const EdgeInsets.symmetric(horizontal: Config.padding),
          height: Config.isDesktop(context) ? 50 : 30,
          child: Center(
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Config.iconColor,
                ),
                SizedBox(width: 15,),
                Text(widget.text,
                    style: TextStyle(
                      color: Config.iconColor,
                      fontSize: Config.fontSizeMedium(context)+2,
                      fontFamily: Config.fontFamily)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
