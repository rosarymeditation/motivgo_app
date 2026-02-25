import 'package:hive/hive.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:rosary/model/goal_occurrence_model.dart';

import '../model/goal_model.dart';
import '../model/user_model.dart';

class HiveStorage {
  static const authBox = 'authBox';
  static const userBox = 'userBox';
  static const goalBox = 'goalBox'; // new box for goals
  static const goalOccurrenceBox = 'goal_occurrences';

  static const _tokenKey = 'token';
  static const userKey = 'me';
  static const _goalKey = 'firstGoal'; // optional key for single goal

  Future<void> saveToken(String token) async {
    final box = Hive.box(authBox);
    await box.put(_tokenKey, token);
  }

  // Future<void> saveGoal(GoalModel goal) async {
  //   final box = Hive.box<GoalModel>(goalBox);
  //   await box.put(_goalKey, goal);
  // }
  // Save a single goal with a Mongo-style ID
  Future<void> saveGoal(GoalModel goal) async {
    final box = Hive.box<GoalModel>(goalBox);

    // Generate a Mongo-like ID if goal.id is null
    final id = goal.id ?? ObjectId().toHexString();
    goal.id = id;

    await box.put(id, goal);
  }

  // Get a single goal by ID
  GoalModel? getGoal(String id) {
    final box = Hive.box<GoalModel>(goalBox);
    return box.get(id);
  }

  // Delete a goal by ID
  Future<void> deleteGoal(String id) async {
    final box = Hive.box<GoalModel>(goalBox);
    await box.delete(id);
  }

  List<GoalModel> getAllGoals() {
    final box = Hive.box<GoalModel>(goalBox);
    return box.values.toList();
  }

  List<GoalOccurrence> getAllOccurences() {
    final box = Hive.box<GoalOccurrence>(goalOccurrenceBox);
    return box.values.toList();
  }

  static Future<void> resetOccurrences() async {
    await Hive.deleteBoxFromDisk(goalOccurrenceBox);
    print('🗑️ Occurrence box wiped');
  }

  GoalModel? getNextGoal() {
    final allGoals = getAllGoals();
    final now = DateTime.now();

    DateTime? closestTime;
    GoalModel? closestGoal;

    for (final goal in allGoals) {
      if (goal.active != true) continue;

      final occurrenceBox = Hive.box<GoalOccurrence>(goalOccurrenceBox);
      final todayKey =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      GoalOccurrence? todayOccurrence;

      try {
        todayOccurrence = occurrenceBox.values.firstWhere(
          (o) => o.goalId == goal.id && o.dateKey == todayKey,
        );
      } catch (e) {
        todayOccurrence = null;
      }

      if (todayOccurrence != null &&
          (todayOccurrence.status == GoalOccurrenceStatus.completed ||
              todayOccurrence.status == GoalOccurrenceStatus.skipped)) {
        continue; // 👈 skip this goal entirely for today
      }

      final nextTime = _calculateNextTrigger(goal, now);

      if (nextTime == null) continue;

      if (closestTime == null || nextTime.isBefore(closestTime)) {
        closestTime = nextTime;
        closestGoal = goal;
      }
    }

    return closestGoal;
  }

  String? getToken() {
    final box = Hive.box(authBox);
    return box.get(_tokenKey);
  }

  Future<void> saveUser(UserModel user) async {
    print("save users--------------------------------------------");
    print(user.toJson());
    final box = Hive.box<UserModel>(userBox);
    await box.put(userKey, user);
  }

  UserModel? getUser() {
    final box = Hive.box<UserModel>(userBox);
    return box.get(userKey);
  }

  Future<void> clearAuth() async {
    await Hive.box(authBox).clear();
    await Hive.box<UserModel>(userBox).clear();
  }

  DateTime? _calculateNextTrigger(GoalModel goal, DateTime now) {
    if (goal.hour == null || goal.minute == null) return null;

    switch (goal.repeatType) {
      case "none":
        if (goal.scheduledAt != null && goal.scheduledAt!.isAfter(now)) {
          return goal.scheduledAt;
        }
        return null;

      case "weekly":
        if (goal.weekdays == null || goal.weekdays!.isEmpty) return null;

        DateTime? closest;

        for (final weekday in goal.weekdays!) {
          DateTime candidate = _nextWeekday(
            weekday,
            goal.hour!,
            goal.minute!,
            now,
          );

          if (closest == null || candidate.isBefore(closest)) {
            closest = candidate;
          }
        }
        return closest;

      case "monthly":
        if (goal.dayOfMonth == null) return null;

        return _nextMonthDay(
          goal.dayOfMonth!,
          goal.hour!,
          goal.minute!,
          now,
        );

      case "yearly":
        return _nextYearly(
          goal.hour!,
          goal.minute!,
          now,
        );

      default:
        return null;
    }
  }

  DateTime _nextMonthDay(
    int day,
    int hour,
    int minute,
    DateTime now,
  ) {
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = DateTime(
        now.year,
        now.month + 1,
        day,
        hour,
        minute,
      );
    }

    return scheduled;
  }

  DateTime _nextYearly(
    int hour,
    int minute,
    DateTime now,
  ) {
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = DateTime(
        now.year + 1,
        now.month,
        now.day,
        hour,
        minute,
      );
    }

    return scheduled;
  }

  DateTime _nextWeekday(
    int weekday,
    int hour,
    int minute,
    DateTime now,
  ) {
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  DateTime? getNextTriggerForGoal(GoalModel goal) {
    return _calculateNextTrigger(goal, DateTime.now());
  }
}
