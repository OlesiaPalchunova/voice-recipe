import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_recipe/local_notice_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:voice_recipe/util.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key, required this.waitTimeMins, required this.id});

  final int waitTimeMins;
  final int id;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Config.borderRadiusLarge)),
      height: Config.pageHeight(context) * _height,
      margin: const EdgeInsets.fromLTRB(0, Config.margin, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimerButton(onPressed: () {
            setState(() {
              _isRunPressed = !_isRunPressed;
            });
            if (_isRunPressed) {
              startTimer();
            } else {
              stopTimer();
            }
          }, icon: Icon(
            _isRunPressed ? Icons.pause_circle : Icons.play_circle,
            color: Colors.black87.withOpacity(0.8),
          )),
          _buildTimerLabel(),
          _buildTimerButton(onPressed: () {
            setState(() {
              resetTimer();
            });
          }, icon: Icon(
            Icons.replay_circle_filled_rounded,
            color: Colors.black87.withOpacity(0.8),
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
      _timer = _prevState!._timer;
      if (_prevState!._isDisposed && _isRunPressed) {
        var current = DateTime.now();
        var diff = current.difference(_prevState!._lastShown).abs();
        var millisLeft = _leftDuration.inMilliseconds - diff.inMilliseconds;
        _leftDuration = Duration(milliseconds: (millisLeft > 0 ? millisLeft: 0));
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
    if (_leftDuration.inSeconds == widget.waitTimeMins * 60) {
      if (Config.notificationsOn) {
        LocalNoticeService().addNotification(
            title: "Время прошло",
            body: "Можно переходить к следующему шагу",
            alarmTime: DateTime.now().add(Duration(seconds: _leftDuration.inSeconds))
        );
      }
    }
    _timer = Timer.periodic(
        const Duration(seconds: _reduceSecondsBy), (_) => setCountDown());
    _isRunPressed = true;
  }

  void stopTimer() {
    setState(() => _timer?.cancel());
  }

  void resetTimer() {
    if (_isDisposed) return;
    stopTimer();
    _isRunPressed = false;
    setState(() => _leftDuration = Duration(minutes: widget.waitTimeMins));
  }

  void setCountDown() {
    final seconds =  _leftDuration.inSeconds - _reduceSecondsBy;
    if (seconds < 0) {
      _timer!.cancel();
      _isRunPressed = false;
      player.stop();
      player.play(AssetSource(alarmAudioPath));
    } else {
      _leftDuration = Duration(seconds: seconds);
    }
    if (!_isDisposed) {
      setState(() {
      });
    }
  }

  Widget _buildTimerButton({required void Function() onPressed, required Icon icon}) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      child: IconButton(
          onPressed: onPressed,
          iconSize: _iconHeight * Config.pageHeight(context),
          icon: icon),
    );
  }

  Widget _buildTimerLabel() {
    const labelWidth = 0.3;
    const fontSize = 0.05;
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits( _leftDuration.inHours.remainder(24));
    final minutes = strDigits( _leftDuration.inMinutes.remainder(60));
    final seconds = strDigits( _leftDuration.inSeconds.remainder(60));
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
            color: Colors.black87),
      ),
    );
  }
}
