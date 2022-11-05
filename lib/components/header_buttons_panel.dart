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
                            color: Colors.black,
                            size: HeaderButtonsPanel._iconSize,
                          )
                        : const Icon(
                            Icons.mic_off,
                            color: Colors.black,
                            size: HeaderButtonsPanel._iconSize,
                          )),
                _isListening ? Colors.white : Colors.white54)
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
