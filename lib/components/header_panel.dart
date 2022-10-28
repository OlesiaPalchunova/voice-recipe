import 'package:flutter/material.dart';

class HeaderPanel extends StatelessWidget {
  const HeaderPanel({super.key, required this.onClose, required this.onList});

  final double _iconSize = 25;
  final double _panelHeight = 45;
  final void Function(BuildContext) onClose;
  final void Function(BuildContext) onList;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: _panelHeight,
            width: _panelHeight,
            child: Image.asset("assets/images/voice_recipe.png")),
        Row(
          children: [
            buildButton(
              context,
              IconButton(
                onPressed: () => onList(context),
                icon: Icon(
                  Icons.list,
                  color: Colors.black,
                  size: _iconSize,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            buildButton(
              context,
              IconButton(
                onPressed: () => onClose(context),
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.black,
                  size: _iconSize,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  static Container buildButton(BuildContext context, IconButton iconButton) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: iconButton);
  }
}
