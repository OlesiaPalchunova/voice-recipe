import 'package:flutter/material.dart';

import 'package:voice_recipe/components/appbars/header_buttons_panel.dart';
import 'package:voice_recipe/config.dart';

class ListenButton extends StatefulWidget {
  const ListenButton({super.key,
    required this.onListen,
    required this.onMute,
    required this.iconSize
  });

  final void Function() onListen;
  final void Function() onMute;
  final double iconSize;

  @override
  State<ListenButton> createState() => ListenButtonState();
}

class ListenButtonState extends State<ListenButton> {
  static var _isListening = false;
  var _locked = false;
  static ListenButtonState? _state;

  static ListenButtonState? current() {
    return _state;
  }

  bool isListening() {
    return _isListening;
  }

  void listen() {
    if (_isListening) return;
    setState(() {
      _isListening = true;
    });
    widget.onListen();
  }

  void stopListening() {
    if (!_isListening) return;
    setState(() {
      _isListening = false;
    });
    widget.onMute();
  }

  void lock() {
    _locked = true;
  }

  void unlock() {
    _locked = false;
  }

  @override
  void initState() {
    super.initState();
    _state = this;
    if (_isListening) {
      widget.onListen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderButtonsPanel.buildButton(
        IconButton(
            onPressed: () {
              if (_locked) return;
              setState(() {
                _isListening = !_isListening;
              });
              if (_isListening) {
                widget.onListen();
              } else {
                widget.onMute();
              }
            },
            icon: _isListening
                ? Icon(
              Icons.mic,
              color: Config.iconColor(),
              size: widget.iconSize,
            )
                : Icon(
              Icons.mic_off,
              color: Config.iconColor(),
              size: widget.iconSize,
            )),
        _isListening ? Config.iconBackColor()
                     : Config.disabledIconBackColor());
  }
}
