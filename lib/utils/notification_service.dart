import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

import '../enums/time_enum.dart';


class AlarmService {
  // ---------------- Singleton ----------------
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ============================================================
  // INIT
  // ============================================================

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print("Alarm tapped: ${response.payload}");
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isAndroid) {
      await _requestAndroidPermission();
    }

    _initialized = true;
  }

  // ============================================================
  // PERMISSION
  // ============================================================

  Future<void> _requestAndroidPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // ============================================================
  // PUBLIC SCHEDULER (MAIN METHOD)
  // ============================================================

  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    RepeatType repeatType = RepeatType.none,
    List<int>? weekdays, // For weekly
    int? dayOfMonth, // For monthly
  }) async {
    await init();

    switch (repeatType) {
      case RepeatType.none:
        await _scheduleOneTime(id, title, body, hour, minute);
        break;

      case RepeatType.weekly:
        if (weekdays == null || weekdays.isEmpty) return;
        await _scheduleWeekly(id, title, body, hour, minute, weekdays);
        break;

      case RepeatType.monthly:
        if (dayOfMonth == null) return;
        await _scheduleMonthly(id, title, body, hour, minute, dayOfMonth);
        break;

      case RepeatType.yearly:
        await _scheduleYearly(id, title, body, hour, minute);
        break;
    }
  }

  // ============================================================
  // ONE TIME
  // ============================================================

  Future<void> _scheduleOneTime(
      int id, String title, String body, int hour, int minute) async {
    final scheduledDate = _nextInstance(hour, minute);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ============================================================
  // WEEKLY (MULTIPLE DAYS SUPPORTED)
  // ============================================================

  Future<void> _scheduleWeekly(
    int id,
    String title,
    String body,
    int hour,
    int minute,
    List<int> weekdays,
  ) async {
    for (int i = 0; i < weekdays.length; i++) {
      final date = _nextInstanceOfWeekday(weekdays[i], hour, minute);

      await _notifications.zonedSchedule(
        id + i,
        title,
        body,
        date,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // ============================================================
  // MONTHLY
  // ============================================================

  Future<void> _scheduleMonthly(
    int id,
    String title,
    String body,
    int hour,
    int minute,
    int dayOfMonth,
  ) async {
    final date = _nextInstanceOfMonth(dayOfMonth, hour, minute);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      date,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ============================================================
  // YEARLY
  // ============================================================

  Future<void> _scheduleYearly(
    int id,
    String title,
    String body,
    int hour,
    int minute,
  ) async {
    final date = _nextInstanceOfYear(hour, minute);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      date,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ============================================================
  // DATE HELPERS
  // ============================================================

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

 tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Move forward until correct weekday AND future time
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfMonth(int day, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month + 1,
        day,
        hour,
        minute,
      );
    }

    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfYear(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        now.year + 1,
        now.month,
        now.day,
        hour,
        minute,
      );
    }

    return scheduled;
  }

  // ============================================================
  // CANCEL
  // ============================================================

  Future<void> cancelAlarm(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllAlarms() async {
    await _notifications.cancelAll();
  }

  // ============================================================
  // NOTIFICATION DETAILS
  // ============================================================

  NotificationDetails _notificationDetails() {
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel_v1',
      'Alarm Channel',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      playSound: true,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound('aiv'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'aiv.wav',
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }
}

// Required for background tap handling
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print("Background notification tapped: ${response.payload}");
}
