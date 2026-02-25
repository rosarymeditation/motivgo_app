import 'package:hive/hive.dart';

import '../model/goal_model.dart';
import '../model/goal_occurrence_model.dart';
import '../utils/hive_storage.dart';
import '../utils/notification_service.dart';

class OccurrenceService {
  static Future<Box<GoalOccurrence>> _openBox() async {
    if (!Hive.isBoxOpen(HiveStorage.goalOccurrenceBox)) {
      return await Hive.openBox<GoalOccurrence>(HiveStorage.goalOccurrenceBox);
    }
    return Hive.box<GoalOccurrence>(HiveStorage.goalOccurrenceBox);
  }

  static Future<GoalOccurrence?> createOccurrence({
    required String goalId,
    required String title,
    required DateTime scheduledAt,
    String? pillar,
    String? motivationStyle,
    String? format,
    String? messageText,
    String? audioUrl,
  }) async {
    final box = await _openBox();
    final dateKey = toDateKey(scheduledAt);

    final exists =
        box.values.any((o) => o.goalId == goalId && o.dateKey == dateKey);
    if (exists) return null;

    final occurrence = GoalOccurrence(
      goalId: goalId,
      dateKey: dateKey,
      scheduledAt: scheduledAt,
      status: GoalOccurrenceStatus.pending,
      pillar: pillar,
      goalTitle: title,
      motivationStyle: motivationStyle,
      format: format,
      messageText: messageText,
      audioUrl: audioUrl,
    );

    await box.add(occurrence);
    return occurrence;
  }

  static Future<List<GoalOccurrence>> getTodayPending() async {
    final box = await _openBox();
    final today = toDateKey(DateTime.now());
    return box.values
        .where((o) =>
            o.dateKey == today && o.status == GoalOccurrenceStatus.pending)
        .toList();
  }

  static String toDateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  static Future<void> markCompleted(
      GoalOccurrence occurrence, GoalModel goal) async {
    occurrence.status = GoalOccurrenceStatus.completed;
    occurrence.checkedInAt = DateTime.now();
    occurrence.updatedAt = DateTime.now();
    await occurrence.save();

    // ✅ Suppress alarm if it hasn't fired yet
    await _suppressAlarmIfNeeded(occurrence, goal);
    print(
        '✅ Marked completed: ${occurrence.goalTitle} | ${occurrence.dateKey}');
  }

  static Future<void> markSkipped(
      GoalOccurrence occurrence, GoalModel goal) async {
    occurrence.status = GoalOccurrenceStatus.skipped;
    occurrence.updatedAt = DateTime.now();
    await occurrence.save();

    // ✅ Suppress alarm if it hasn't fired yet
    await _suppressAlarmIfNeeded(occurrence, goal);
    print('⏭️ Marked skipped: ${occurrence.goalTitle} | ${occurrence.dateKey}');
  }

  static Future<void> _suppressAlarmIfNeeded(
    GoalOccurrence occurrence,
    GoalModel goal,
  ) async {
    if (goal.alarmId == null) return;

    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      goal.hour ?? 0,
      goal.minute ?? 0,
    );

    // Only suppress if alarm hasn't fired yet today
    if (now.isBefore(alarmTime)) {
      print(
          '🔕 Suppressing alarm ${goal.alarmId} — fires at $alarmTime, now is $now');
      await AlarmService().suppressForToday(
        alarmId: goal.alarmId!,
        title: goal.title ?? 'Goal Reminder',
        body: 'Time for ${goal.title}!',
        hour: goal.hour ?? 0,
        minute: goal.minute ?? 0,
        repeatType: goal.repeatType ?? 'none',
        weekdays: goal.weekdays,
        dayOfMonth: goal.dayOfMonth,
      );
    } else {
      print('⏰ Alarm already fired — no suppression needed');
    }
  }
}
