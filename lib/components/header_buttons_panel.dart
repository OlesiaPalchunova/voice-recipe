import 'package:flutter/material.dart';
import 'package:voice_recipe/config.dart';

class HeaderButtonsPanel extends StatefulWidget {
  const HeaderButtonsPanel(
      {super.key,
      required this.onClose,
      required this.onList,
      required this.onSay,
      required this.onListen,
      required this.onMute,
      required this.id});

  static const _iconSize = 25.0;
  final void Function(BuildContext) onClose;
  final void Function() onList;
  final void Function() onSay;
  final void Function() onListen;
  final void Function() onMute;
  final int id;

  @override
  State<HeaderButtonsPanel> createState() => HeaderButtonsPanelState();

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

class HeaderButtonsPanelState extends State<HeaderButtonsPanel> {
  static var _isListening = false;
  static HeaderButtonsPanelState? _currentState;
  var _isButtonBlocked = false;
  var _wasListeningBeforeBlock = true;
  static const backColor = Colors.white;
  static const iconColor = Colors.black87;

  static HeaderButtonsPanelState? getCurrent() {
    return _currentState;
  }

  void stopListening() async {
    if (_isButtonBlocked) {
      return;
    }
    _isButtonBlocked = true;
    _wasListeningBeforeBlock = _isListening;
    if (_isListening) {
      widget.onMute();
    }
    debugPrint('stopListening()');
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _isListening = false;
    });
  }

  void startListening() async {
    if (!_isButtonBlocked) {
      return;
    }
    _isButtonBlocked = false;
    if (!_wasListeningBeforeBlock) {
      return;
    }
    if (!_isListening) {
      widget.onListen();
    }
    debugPrint('startListening()');
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _isListening = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentState = this;
    if (_isListening) {
      widget.onListen();
    }
  }

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
                      if (_isButtonBlocked) return;
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
                        ? const Icon(
                            Icons.mic,
                            color: iconColor,
                            size: HeaderButtonsPanel._iconSize,
                          )
                        : const Icon(
                            Icons.mic_off,
                            color: iconColor,
                            size: HeaderButtonsPanel._iconSize,
                          )),
                _isListening ? backColor : backColor.withOpacity(0.6))
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
                    color: iconColor,
                    size: HeaderButtonsPanel._iconSize,
                  ),
                ),
                backColor),
            const SizedBox(
              width: 10,
            ),
            HeaderButtonsPanel.buildButton(
                context,
                IconButton(
                  onPressed: () => widget.onClose(context),
                  icon: const Icon(
                    Icons.close_outlined,
                    color: iconColor,
                    size: HeaderButtonsPanel._iconSize,
                  ),
                ),
                backColor),
          ],
        )
      ],
    );
  }
}
