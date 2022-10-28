import 'package:flutter/material.dart';

class HeaderPanel extends StatefulWidget {
  const HeaderPanel({super.key, required this.onClose, required this.onList,
  required this.onListen, required this.onMute});

  static const _iconSize = 25.0;
  final void Function(BuildContext) onClose;
  final void Function() onList;
  final void Function() onListen;
  final void Function() onMute;

  @override
  State<HeaderPanel> createState() => _HeaderPanelState();

  static Container buildButton(BuildContext context, IconButton iconButton) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: iconButton);
  }
}

class _HeaderPanelState extends State<HeaderPanel> {
  var isListening = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: const Image(
                  height: 48.0,
                  image: AssetImage("assets/images/voice_recipe.png")),
            ),
            const SizedBox(
              width: 10,
            ),
            HeaderPanel.buildButton(
                context,
                IconButton(
                    onPressed: () {
                      setState(() {
                        isListening = !isListening;
                      });
                      if (isListening) {
                        widget.onListen();
                      } else {
                        widget.onMute();
                      }
                    },
                    icon: isListening ? const Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: HeaderPanel._iconSize,
                    ) : const Icon(
                      Icons.mic_off,
                      color: Colors.black,
                      size: HeaderPanel._iconSize,
                    )))
          ],
        ),
        Row(
          children: [
            HeaderPanel.buildButton(
              context,
              IconButton(
                onPressed: () => widget.onList(),
                icon: const Icon(
                  Icons.list,
                  color: Colors.black,
                  size: HeaderPanel._iconSize,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            HeaderPanel.buildButton(
              context,
              IconButton(
                onPressed: () => widget.onClose(context),
                icon: const Icon(
                  Icons.close_outlined,
                  color: Colors.black,
                  size: HeaderPanel._iconSize,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
