// lib/service/seed_service.dart

import 'package:hive/hive.dart';
import 'package:motivgo/utils/hive_storage.dart';
import '../model/goal_occurrence_model.dart';
import '../service/occurrence_service.dart';

class SeedService {
  static Future<void> seedFakeOccurrences() async {
    final box = Hive.box<GoalOccurrence>(HiveStorage.goalOccurrenceBox);

    if (box.isNotEmpty) {
      print('🌱 Seed skipped — already contains ${box.length} records');
      return;
    }

    final now = DateTime.now();
    final todayKey = OccurrenceService.toDateKey(now);

    final fakeGoals = [
      _goal('goal_001', 'Morning Meditation', 'Health & Fitness', 6, 0, 29),
      _goal('goal_002', 'Read 10 Pages', 'Personal Growth', 8, 30, 25),
      _goal('goal_003', 'Revenue Review', 'Business & Money', 9, 0, 20),
      _goal('goal_004', 'Evening Run', 'Health & Fitness', 18, 0, 27),
      _goal('goal_005', 'Journaling', 'Personal Growth', 21, 0, 15),
      _goal('goal_006', 'Cold Shower', 'Health & Fitness', 7, 0, 10),
      _goal('goal_007', 'Sales Follow-ups', 'Business & Money', 10, 0, 22),
      _goal('goal_008', 'Gratitude Practice', 'Personal Growth', 6, 30, 18),
      _goal('goal_009', 'Drink 3L Water', 'Health & Fitness', 7, 30, 29),
      _goal('goal_010', 'Budget Check', 'Business & Money', 20, 0, 12),
      _goal('goal_011', 'Stretching Routine', 'Health & Fitness', 7, 0, 8),
      _goal('goal_012', 'Learn New Skill', 'Personal Growth', 19, 0, 14),
      _goal('goal_013', 'Prayer & Devotion', 'Faith', 5, 30, 29),
      _goal('goal_014', 'Network Outreach', 'Business & Money', 11, 0, 7),
      _goal('goal_015', 'Healthy Breakfast', 'Health & Fitness', 7, 0, 29),
      _goal('goal_016', 'Weekly Planning', 'Personal Growth', 17, 0, 21),
      _goal('goal_017', 'Podcast Learning', 'Personal Growth', 12, 0, 5),
      _goal('goal_018', 'Evening Walk', 'Health & Fitness', 19, 30, 16),
      _goal('goal_019', 'Savings Transfer', 'Business & Money', 9, 0, 3),
      _goal('goal_020', 'Digital Detox Hour', 'Personal Growth', 21, 30, 11),
    ];

    int count = 0;

    for (final goal in fakeGoals) {
      final startDaysAgo = goal['startDaysAgo'] as int;

      // Seed historical days (exclude today)
      for (int daysAgo = startDaysAgo; daysAgo > 0; daysAgo--) {
        final day = now.subtract(Duration(days: daysAgo));
        final dateKey = OccurrenceService.toDateKey(day);

        final status = _generateStatus(daysAgo, goal['id'] as String);

        final occurrence = GoalOccurrence(
          goalId: goal['id'] as String,
          goalTitle: goal['title'] as String,
          dateKey: dateKey,
          scheduledAt: DateTime(
            day.year,
            day.month,
            day.day,
            goal['hour'] as int,
            goal['minute'] as int,
          ),
          status: status,
          checkedInAt: status == GoalOccurrenceStatus.completed
              ? DateTime(
                  day.year,
                  day.month,
                  day.day,
                  (goal['hour'] as int) + 1,
                )
              : null,
          pillar: goal['pillar'] as String,
          motivationStyle: 'motivational',
          format: 'text',
        );

        await box.add(occurrence);
        count++;
      }

      // ✅ Explicitly add TODAY occurrence (always pending)
      final todayOccurrence = GoalOccurrence(
        goalId: goal['id'] as String,
        goalTitle: goal['title'] as String,
        dateKey: todayKey,
        scheduledAt: DateTime(
          now.year,
          now.month,
          now.day,
          goal['hour'] as int,
          goal['minute'] as int,
        ),
        status: GoalOccurrenceStatus.pending,
        checkedInAt: null,
        pillar: goal['pillar'] as String,
        motivationStyle: 'motivational',
        format: 'text',
      );

      await box.add(todayOccurrence);
      count++;
    }

    print(
        '✅ Seeded $count fake occurrences (~90% completion rate + today pending)');
  }

  static Map<String, dynamic> _goal(
    String id,
    String title,
    String pillar,
    int hour,
    int minute,
    int startDaysAgo,
  ) {
    return {
      'id': id,
      'title': title,
      'pillar': pillar,
      'hour': hour,
      'minute': minute,
      'startDaysAgo': startDaysAgo,
    };
  }

  static GoalOccurrenceStatus _generateStatus(int daysAgo, String goalId) {
    const double completionRate = 0.90;
    const double skipRate = 0.05;

    final seed = (daysAgo * goalId.hashCode).abs() % 100;

    final completionThreshold = (completionRate * 100).round();
    final skipThreshold = completionThreshold + (skipRate * 100).round();

    if (seed < completionThreshold) {
      return GoalOccurrenceStatus.completed;
    } else if (seed < skipThreshold) {
      return GoalOccurrenceStatus.skipped;
    } else {
      return GoalOccurrenceStatus.pending;
    }
  }

  static Future<void> resetAndReseed() async {
    final box = Hive.box<GoalOccurrence>(HiveStorage.goalOccurrenceBox);
    await box.clear();
    print('🗑️ Cleared all occurrences');
    await seedFakeOccurrences();
  }
}
