// lib/services/midnight_trigger.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../model/goal_model.dart';
import '../model/goal_occurrence_model.dart';
import '../model/user_model.dart';
import '../utils/hive_storage.dart';
import 'goal_service.dart';
import 'occurrence_service.dart';

// ✅ MUST be top-level — outside the class
@pragma('vm:entry-point')
void onBackgroundNotificationResponse(NotificationResponse response) async {
  if (response.id != 99) return;

  print('🌙 [BACKGROUND] Midnight job triggered');

  // Re-init Hive in background isolate (isolate has no memory of main's init)
  await Hive.initFlutter();

  // ✅ Guard each adapter — avoids "already registered" crash
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserModelAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GoalModelAdapter());
  if (!Hive.isAdapterRegistered(5))
    Hive.registerAdapter(GoalOccurrenceStatusAdapter());
  if (!Hive.isAdapterRegistered(2))
    Hive.registerAdapter(GoalOccurrenceAdapter());

  // ✅ Open boxes only if not already open
  if (!Hive.isBoxOpen(HiveStorage.goalBox)) {
    await Hive.openBox<GoalModel>(HiveStorage.goalBox);
  }
  if (!Hive.isBoxOpen(HiveStorage.goalOccurrenceBox)) {
    await Hive.openBox<GoalOccurrence>(HiveStorage.goalOccurrenceBox);
  }

  await _generateOccurrences();
}

// ✅ Top-level — shared by both foreground and background handlers
Future<void> _generateOccurrences() async {
  final dueToday = await GoalService.getGoalsDueToday(); // await needed
  print('📋 Goals due today: ${dueToday.length}');

  for (final goal in dueToday) {
    if (goal.id == null) continue;

    await OccurrenceService.createOccurrence(
      goalId: goal.id!,
      title: goal.title ?? "",
      scheduledAt: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        goal.hour ?? 0,
        goal.minute ?? 0,
      ),
      pillar: goal.pillar,
      motivationStyle: goal.motivationStyle,
      format: goal.format,
    );
  }

  print('✅ Done — ${dueToday.length} occurrences processed');
}

// ─────────────────────────────────────────────────────
// CLASS — below all top-level functions
// ─────────────────────────────────────────────────────
class MidnightTrigger {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 99;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onForegroundTrigger,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse, // ✅ top-level above
    );

    print('✅ MidnightTrigger initialized');
  }

  static Future<void> schedule() async {
    await _plugin.cancel(_notificationId);

    final now = tz.TZDateTime.now(tz.local);

    var midnight = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      0, // hour → midnight
      0, // minute
    );

    if (midnight.isBefore(now)) {
      midnight = midnight.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      _notificationId,
      '🌙 Daily Goal Check-in',
      'Your goals are waiting — check in now!',
      midnight,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_trigger_channelswe',
          'Daily Goal Triggers',
          channelDescription: 'Fires at midnight to log daily goal occurrences',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: // ✅ ADD THIS
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('⏰ Midnight trigger scheduled for: $midnight');
  }

  static void _onForegroundTrigger(NotificationResponse response) async {
    if (response.id != _notificationId) return;
    print('🌙 [FOREGROUND] Midnight job triggered');
    await _generateOccurrences();
  }

  static Future<void> catchUpMissedOccurrences() async {
    print('🔄 Running catch-up check...');
    await _generateOccurrences();
  }
}
