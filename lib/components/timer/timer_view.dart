import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_recipe/services/local_notice_service.dart';

// import 'package:audioplayers/audioplayers.dart';
import 'package:voice_recipe/config/config.dart';

class TimerView extends StatefulWidget {
  TimerView(
      {key,
      required this.waitTimeMins,
      required this.id,
      this.colorId = 0,
      required this.alarmText}) {
    if (runNotifyers.containsKey(id)) return;
    runNotifyers[id] = ValueNotifier(false);
    resetNotifyers[id] = ValueNotifier(false);
  }

  final int waitTimeMins;
  final int id;
  final int colorId;
  final String alarmText;

  @override
  State<TimerView> createState() => _TimerViewState();

  static final Map<int, ValueNotifier<bool>> runNotifyers = {};
  static final Map<int, ValueNotifier<bool>> resetNotifyers = {};
}

class _TimerViewState extends State<TimerView> {
  // static final AudioPlayer player = AudioPlayer();
  static const alarmAudioPath = "sounds/relax-message-tone.mp3";
  late var runNotifyer = TimerView.runNotifyers[widget.id]!;

  bool disposed = false;
  bool noticed = false;
  Timer? timer;
  late Duration leftDuration;
  var lastShown = DateTime.now();
  _TimerViewState? prevState;
  static final Map<int, _TimerViewState?> statesTable = {};

  double get iconSize => 45;

  late bool isRunning = TimerView.runNotifyers[widget.id]!.value;

  @override
  void initState() {
    super.initState();
    initTimerInfo();
  }

  BoxDecoration _getTimerBoxDecoration() {
    var gradientColor = Config.getGradientColor(widget.colorId);
    return BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: !Config.darkModeOn
                ? gradientColor.first.withOpacity(.4)
                : gradientColor.last.withOpacity(.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
        borderRadius: Config.borderRadiusLarge);
  }

  Color get contentColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TimerView.resetNotifyers[widget.id]!,
      builder: (context, bool newIsReset, child) {
        if (newIsReset) {
          resetTimer();
          TimerView.resetNotifyers[widget.id]!.value = false;
        }
        return ValueListenableBuilder(
            valueListenable: TimerView.runNotifyers[widget.id]!,
            builder: (context, bool newIsRunning, child) {
              if (newIsRunning != isRunning) {
                isRunning = newIsRunning;
                if (isRunning) {
                  startTimer();
                } else {
                  stopTimer();
                }
              }
              return Container(
                decoration: _getTimerBoxDecoration(),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildTimerButton(
                        onPressed: () {
                          setState(() {
                            isRunning = !isRunning;
                            TimerView.runNotifyers[widget.id]!.value = isRunning;
                          });
                          if (isRunning) {
                            startTimer();
                          } else {
                            stopTimer();
                          }
                        },
                        icon: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          color: contentColor,
                          size: iconSize,
                        )),
                    buildTimerLabel(),
                    buildTimerButton(
                        onPressed: () {
                          setState(() {
                            resetTimer();
                          });
                        },
                        icon: Icon(
                          Icons.replay,
                          color: contentColor,
                          size: iconSize,
                        ))
                  ],
                ),
              );
            });
      },
    );
  }

  void initTimerInfo() {
    if (statesTable.containsKey(widget.id)) {
      prevState = statesTable[widget.id];
    }
    if (prevState != null) {
      leftDuration = prevState!.leftDuration;
      isRunning = prevState!.isRunning;
      noticed = prevState!.noticed;
      timer = prevState!.timer;
      if (prevState!.disposed && isRunning) {
        var current = DateTime.now();
        var diff = current.difference(prevState!.lastShown).abs();
        var millisLeft = leftDuration.inMilliseconds - diff.inMilliseconds;
        leftDuration =
            Duration(milliseconds: (millisLeft > 0 ? millisLeft : 0));
        startTimer();
      }
    } else {
      leftDuration = Duration(minutes: widget.waitTimeMins);
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
    timer?.cancel();
    timer = null;
    lastShown = DateTime.now();
    statesTable[widget.id] = this;
  }

  void startTimer() {
    if (disposed) {
      return;
    }
    if (leftDuration.inSeconds == 0) {
      resetTimer();
      startTimer();
      return;
    }
    if (Config.notificationsOn && !noticed) {
      LocalNoticeService().addNotification(
          id: widget.id,
          title: "Время прошло",
          body: widget.alarmText,
          alarmTime: DateTime.now().add(leftDuration));
      noticed = true;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    isRunning = true;
  }

  void stopTimer() {
    setState(() => timer?.cancel());
    LocalNoticeService().cancelNotification(id: widget.id);
    noticed = false;
    isRunning = false;
  }

  void resetTimer() {
    if (disposed) return;
    stopTimer();
    runNotifyer.value = false;
    setState(() => leftDuration = Duration(minutes: widget.waitTimeMins));
  }

  void setCountDown() {
    final seconds = leftDuration.inSeconds - 1;
    if (seconds < 0) {
      timer!.cancel();
      isRunning = false;
      // player.stop();
      // player.play(AssetSource(alarmAudioPath));
    } else {
      leftDuration = Duration(seconds: seconds);
    }
    if (!disposed) {
      setState(() {});
    }
  }

  Widget buildTimerButton(
      {required void Function() onPressed, required Icon icon}) {
    return Container(
      padding: const EdgeInsets.all(Config.padding),
      child: IconButton(
          onPressed: onPressed,
          iconSize: iconSize,
          padding: const EdgeInsets.all(0.0),
          icon: icon),
    );
  }

  Widget buildTimerLabel() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(leftDuration.inHours.remainder(24));
    final minutes = strDigits(leftDuration.inMinutes.remainder(60));
    final seconds = strDigits(leftDuration.inSeconds.remainder(60));
    return Text(
      leftDuration.inHours == 0
          ? "$minutes:$seconds"
          : "$hours:$minutes:$seconds",
      style: TextStyle(
        fontFamily: Config.fontFamily,
        fontSize: Config.fontSizeMedium(context) + 20,
        color: contentColor,
      ),
    );
  }
}
