import 'package:flutter/material.dart';

class HeaderButtonsPanel extends StatefulWidget {
  const HeaderButtonsPanel(
      {super.key,
      required this.onClose,
      required this.onList,
      required this.onListen,
      required this.onMute});

  static const _iconSize = 25.0;
  final void Function(BuildContext) onClose;
  final void Function() onList;
  final void Function() onListen;
  final void Function() onMute;

  @override
  State<HeaderButtonsPanel> createState() => _HeaderButtonsPanelState();

  static Container buildButton(
      BuildContext context, IconButton iconButton, Color color) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: iconButton);
  }
}

class _HeaderButtonsPanelState extends State<HeaderButtonsPanel> {
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
            HeaderButtonsPanel.buildButton(
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
                    icon: isListening
                        ? const Icon(
                            Icons.mic,
                            color: Colors.black,
                            size: HeaderButtonsPanel._iconSize,
                          )
                        : const Icon(
                            Icons.mic_off,
                            color: Colors.black,
                            size: HeaderButtonsPanel._iconSize,
                          )),
                isListening ? Colors.white : Colors.white54)
          ],
        ),
        Row(
          children: [
            HeaderButtonsPanel.buildButton(
                context,
                IconButton(
                  onPressed: () => widget.onList(),
                  icon: const Icon(
                    Icons.list,
                    color: Colors.black,
                    size: HeaderButtonsPanel._iconSize,
                  ),
                ),
                Colors.white),
            const SizedBox(
              width: 10,
            ),
            HeaderButtonsPanel.buildButton(
                context,
                IconButton(
                  onPressed: () => widget.onClose(context),
                  icon: const Icon(
                    Icons.close_outlined,
                    color: Colors.black,
                    size: HeaderButtonsPanel._iconSize,
                  ),
                ),
                Colors.white),
          ],
        )
      ],
    );
  }
}
