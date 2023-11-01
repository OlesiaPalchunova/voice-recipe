import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config/config.dart';

import '../../services/service_io.dart';

class ListenButton extends StatefulWidget {
  const ListenButton({key,
    required this.onListen,
    required this.onMute,
    required this.iconSize,
    required this.listenNotifyer,
    required this.isLocked
  });

  final ValueNotifier<bool> isLocked;
  final ValueNotifier<bool> listenNotifyer;
  final void Function() onListen;
  final void Function() onMute;

  final double iconSize;

  @override
  State<ListenButton> createState() => _ListenButtonState();
}

class _ListenButtonState extends State<ListenButton> {
  late bool isListening = widget.listenNotifyer.value;

  @override
  void initState() {
    super.initState();
    if (isListening) {
      widget.onListen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.listenNotifyer,
      builder: (context, bool newIsListening, child) {
        if (newIsListening != isListening) {
          isListening = newIsListening;
          if (newIsListening) {
            widget.onListen();
          } else {
            widget.onMute();
          }
        }
        return ValueListenableBuilder(
          valueListenable: widget.isLocked,
          builder: (context, bool isLocked, child) {
            return HeaderButtonsPanel.buildButton(
                IconButton(
                    onPressed: () {
                      if (Config.isWeb) {
                        ServiceIO.showAlertDialog(
                            "К сожалению, голосове управление на данный момент работает только в мобильной версии.",
                            context);
                        return;
                      }
                      if (isLocked) return;
                      setState(() {
                        isListening = !isListening;
                        widget.listenNotifyer.value = isListening;
                      });
                      if (isListening) {
                        widget.onListen();
                      } else {
                        widget.onMute();
                      }
                    },
                    tooltip: "Голосовое управление",
                    icon: widget.listenNotifyer.value
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
                widget.listenNotifyer.value ? Config.iconBackColor
                    : Config.disabledIconBackColor);
          },
        );
      }
    );
  }
}
