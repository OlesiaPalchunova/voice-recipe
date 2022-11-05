import 'dart:async';

import 'package:flutter/material.dart';

import 'package:voice_recipe/components/util.dart';

class CookTimer extends StatefulWidget {
  const CookTimer({super.key, required this.waitTimeMins, required this.id});

  final int waitTimeMins;
  final int id;

  @override
  State<CookTimer> createState() => CookTimerState();
}

class CookTimerState extends State<CookTimer> {
  static const _height = 0.1;
  static const _iconHeight = 0.1 * 0.6;
  static const _reduceSecondsBy = 1;

  bool _isRunPressed = false;
  bool _isDisposed = false;
  Timer? _timer;
  late Duration _leftDuration;
  var _lastShown = DateTime.now();

  CookTimerState? _prevState;
  static final Map<int, CookTimerState?> _statesTable = {};
  static CookTimerState? _current;

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
          borderRadius: BorderRadius.circular(Util.borderRadiusLarge)),
      height: Util.pageHeight(context) * _height,
      margin: const EdgeInsets.fromLTRB(0, Util.margin, 0, 0),
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

  static CookTimerState? getCurrent() {
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
        var secsLeft = _leftDuration.inSeconds - diff.inSeconds;
        _leftDuration = Duration(seconds: (secsLeft > 0 ? secsLeft: 0));
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
    _timer = Timer.periodic(
        const Duration(seconds: _reduceSecondsBy), (_) => setCountDown());
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
      padding: const EdgeInsets.all(Util.padding),
      child: IconButton(
          onPressed: onPressed,
          iconSize: _iconHeight * Util.pageHeight(context),
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
      width: labelWidth * Util.pageWidth(context),
      child: Text(
        _leftDuration.inHours == 0
            ? "$minutes:$seconds"
            : "$hours:$minutes:$seconds",
        style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: fontSize * Util.pageHeight(context),
            color: Colors.black87),
      ),
    );
  }
}
