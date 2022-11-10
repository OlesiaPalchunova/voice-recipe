import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_recipe/local_notice_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:voice_recipe/config.dart';

class TimerView extends StatefulWidget {
  const TimerView(
      {super.key,
      required this.waitTimeMins,
      required this.id,
      required this.alarmText});

  final int waitTimeMins;
  final int id;
  final String alarmText;

  @override
  State<TimerView> createState() => TimerViewState();
}

class TimerViewState extends State<TimerView> {
  static const _height = 0.1;
  static const _iconHeight = 0.1 * 0.6;
  static const _reduceSecondsBy = 1;
  static final AudioPlayer player = AudioPlayer();
  static const alarmAudioPath = "sounds/relax-message-tone.mp3";

  bool _isRunPressed = false;
  bool _isDisposed = false;
  bool _noticed = false;
  Timer? _timer;
  late Duration _leftDuration;
  var _lastShown = DateTime.now();

  TimerViewState? _prevState;
  static final Map<int, TimerViewState?> _statesTable = {};
  static TimerViewState? _current;

  @override
  void initState() {
    super.initState();
    _current = this;
    _initTimerInfo();
  }

  BoxDecoration _getTimerBoxDecoration() {
    var gradientColor = Config.getGradientColor(widget.id);
    if (Config.darkModeOn) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColor.last.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(Config.borderRadiusLarge),
      );
    }
    return BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(Config.borderRadiusLarge)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getTimerBoxDecoration(),
      height: Config.pageHeight(context) * _height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimerButton(
              onPressed: () {
                setState(() {
                  _isRunPressed = !_isRunPressed;
                });
                if (_isRunPressed) {
                  startTimer();
                } else {
                  stopTimer();
                }
              },
              icon: Icon(
                _isRunPressed ? Icons.pause_outlined : Icons.play_arrow,
                color: Config.iconColor(),
              )),
          _buildTimerLabel(),
          _buildTimerButton(
              onPressed: () {
                setState(() {
                  resetTimer();
                });
              },
              icon: Icon(
                Icons.replay,
                color: Config.iconColor(),
                size: _iconHeight * Config.pageHeight(context) * 0.9,
              ))
        ],
      ),
    );
  }

  static TimerViewState? getCurrent() {
    return _current;
  }

  void _initTimerInfo() {
    if (_statesTable.containsKey(widget.id)) {
      _prevState = _statesTable[widget.id];
    }
    if (_prevState != null) {
      _leftDuration = _prevState!._leftDuration;
      _isRunPressed = _prevState!._isRunPressed;
      _noticed = _prevState!._noticed;
      _timer = _prevState!._timer;
      if (_prevState!._isDisposed && _isRunPressed) {
        var current = DateTime.now();
        var diff = current.difference(_prevState!._lastShown).abs();
        var millisLeft = _leftDuration.inMilliseconds - diff.inMilliseconds;
        _leftDuration =
            Duration(milliseconds: (millisLeft > 0 ? millisLeft : 0));
        startTimer();
      }
    } else {
      _leftDuration = Duration(minutes: widget.waitTimeMins);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    _lastShown = DateTime.now();
    _statesTable[widget.id] = this;
  }

  void startTimer() {
    if (_isDisposed) {
      return;
    }
    if (_leftDuration.inSeconds == 0) {
      return;
    }
    if (Config.notificationsOn && !_noticed) {
      LocalNoticeService().addNotification(
          id: widget.id,
          title: "Время прошло",
          body: widget.alarmText,
          alarmTime: DateTime.now().add(_leftDuration));
      _noticed = true;
    }
    _timer = Timer.periodic(
        const Duration(seconds: _reduceSecondsBy), (_) => setCountDown());
    _isRunPressed = true;
  }

  void stopTimer() {
    setState(() => _timer?.cancel());
    LocalNoticeService().cancelNotification(id: widget.id);
    _noticed = false;
    _isRunPressed = false;
  }

  void resetTimer() {
    if (_isDisposed) return;
    stopTimer();
    _isRunPressed = false;
    setState(() => _leftDuration = Duration(minutes: widget.waitTimeMins));
  }

  void setCountDown() {
    final seconds = _leftDuration.inSeconds - _reduceSecondsBy;
    if (seconds < 0) {
      _timer!.cancel();
      _isRunPressed = false;
      player.stop();
      player.play(AssetSource(alarmAudioPath));
    } else {
      _leftDuration = Duration(seconds: seconds);
    }
    if (!_isDisposed) {
      setState(() {});
    }
  }

  Widget _buildTimerButton(
      {required void Function() onPressed, required Icon icon}) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      child: IconButton(
          onPressed: onPressed,
          iconSize: _iconHeight * Config.pageHeight(context),
          icon: icon),
    );
  }

  Color _getDigitsColor() {
    if (Config.darkModeOn) {
      return Colors.white;
    }
    return Colors.black87;
  }

  Widget _buildTimerLabel() {
    const labelWidth = 0.4;
    const fontSize = 0.05;
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(_leftDuration.inHours.remainder(24));
    final minutes = strDigits(_leftDuration.inMinutes.remainder(60));
    final seconds = strDigits(_leftDuration.inSeconds.remainder(60));
    return Container(
      alignment: Alignment.center,
      width: labelWidth * Config.pageWidth(context),
      child: Text(
        _leftDuration.inHours == 0
            ? "$minutes:$seconds"
            : "$hours:$minutes:$seconds",
        style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: fontSize * Config.pageHeight(context),
            color: _getDigitsColor(),
            ),
      ),
    );
  }
}
