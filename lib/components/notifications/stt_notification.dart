import 'package:flutter/material.dart';

enum Command {
  next, back, start, exit
}

class SttNotification extends Notification {
  final Command command;

  SttNotification({required this.command});
}
