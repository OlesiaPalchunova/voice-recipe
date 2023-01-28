import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config/config.dart';

class ListenButton extends StatefulWidget {
  const ListenButton({super.key,
    required this.onListen,
    required this.onMute,
    required this.iconSize,
    required this.isListening,
    required this.isLocked
  });

  final ValueNotifier<bool> isLocked;
  final ValueNotifier<bool> isListening;
  final void Function() onListen;
  final void Function() onMute;

  final double iconSize;

  @override
  State<ListenButton> createState() => _ListenButtonState();
}

class _ListenButtonState extends State<ListenButton> {

  @override
  void initState() {
    super.initState();
    if (widget.isListening.value) {
      widget.onListen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.isListening,
      builder: (context, isListening, child) {
        if (isListening) {
          widget.onListen();
        } else {
          widget.onMute();
        }
        return ValueListenableBuilder(
          valueListenable: widget.isLocked,
          builder: (context, isLocked, child) {
            return HeaderButtonsPanel.buildButton(
                IconButton(
                    onPressed: () {
                      if (isLocked) return;
                      setState(() {
                        widget.isListening.value = !widget.isListening.value;
                      });
                      if (widget.isListening.value) {
                        widget.onListen();
                      } else {
                        widget.onMute();
                      }
                    },
                    tooltip: "Голосовое управление",
                    icon: widget.isListening.value
                        ? Icon(
                      Icons.mic,
                      color: Config.iconColor,
                      size: widget.iconSize,
                    )
                        : Icon(
                      Icons.mic_off,
                      color: Config.iconColor,
                      size: widget.iconSize,
                    )),
                widget.isListening.value ? Config.iconBackColor
                    : Config.disabledIconBackColor);
          },
        );
      }
    );
  }
}
