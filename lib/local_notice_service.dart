import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNoticeService {
  static final LocalNoticeService _notificationService =
  LocalNoticeService._internal();

  factory LocalNoticeService() {
    return _notificationService;
  }

  LocalNoticeService._internal();

  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();

    const initSettings =
    InitializationSettings(android: androidSetting, iOS: iosSetting);

    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  void cancelNotification({required int id}) {
    _localNotificationsPlugin.cancel(id);
  }

  Future<void> addNotification({
      required int id,
      required String title,
      required String body,
      required DateTime alarmTime,
        String sound = '',
        String channel = 'default',
  }) async {
    tzData.initializeTimeZones();
    final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local,
        alarmTime.millisecondsSinceEpoch);
    final androidDetail = AndroidNotificationDetails(
        channel, // channel Id
        channel,  // channel Name,
      usesChronometer: true
    );
    const iosDetail = DarwinNotificationDetails();
    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
