import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;

  AlarmService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// ------------------------------
  /// INIT
  /// ------------------------------
  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone database
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

    // Request Android 13+ permission
    if (Platform.isAndroid) {
      await _requestAndroidPermission();
    }

    _initialized = true;
  }

  /// ------------------------------
  /// ANDROID PERMISSION (Android 13+)
  /// ------------------------------
  Future<void> _requestAndroidPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// ------------------------------
  /// SCHEDULE ALARM
  /// ------------------------------
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await init();
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel_v1', // change ID if testing again
      'Alarm Channel',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      sound: const RawResourceAndroidNotificationSound('aiv'),
    );
    // final androidDetails = AndroidNotificationDetails(
    //   'alarm_channel3',
    //   'Alarm',
    //   channelDescription: 'Alarm notifications',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   category: AndroidNotificationCategory.alarm,
    //   fullScreenIntent: true,
    //   audioAttributesUsage: AudioAttributesUsage.alarm,
    //   enableVibration: true,
    //   playSound: true,
    //   ticker: 'Alarm',
    //   sound: const RawResourceAndroidNotificationSound(
    //     'aiv', // NO .mp3 extension
    //   ),
    // );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'aiv.wav', // must exist in Runner project
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// ------------------------------
  /// CANCEL ONE
  /// ------------------------------
  Future<void> cancelAlarm(int id) async {
    await _notifications.cancel(id);
  }

  /// ------------------------------
  /// CANCEL ALL
  /// ------------------------------
  Future<void> cancelAllAlarms() async {
    await _notifications.cancelAll();
  }
}

/// Required for background tap handling (Android)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print("Background notification tapped: ${response.payload}");
}
