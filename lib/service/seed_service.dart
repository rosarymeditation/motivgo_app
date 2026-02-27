// lib/service/seed_service.dart

import 'package:hive/hive.dart';
import '../model/goal_occurrence_model.dart';
import '../service/occurrence_service.dart';

class SeedService {
  static Future<void> seedFakeOccurrences() async {
    final box = Hive.box<GoalOccurrence>('goal_occurrences');

    if (box.isNotEmpty) {
      print('🌱 Seed skipped — box already has ${box.length} records');
      return;
    }

    final now = DateTime.now();
    final today = OccurrenceService.toDateKey(now);

    final fakeGoals = [
      {
        'id': 'goal_001',
        'title': 'Morning Meditation',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'calm',
        'format': 'text',
        'hour': 6,
        'minute': 0,
        'startDaysAgo': 29,
      },
      {
        'id': 'goal_002',
        'title': 'Read 10 Pages',
        'pillar': 'Personal Growth',
        'motivationStyle': 'motivational',
        'format': 'text',
        'hour': 8,
        'minute': 30,
        'startDaysAgo': 25,
      },
      {
        'id': 'goal_003',
        'title': 'Revenue Review',
        'pillar': 'Business & Money',
        'motivationStyle': 'analytical',
        'format': 'text',
        'hour': 9,
        'minute': 0,
        'startDaysAgo': 20,
      },
      {
        'id': 'goal_004',
        'title': 'Evening Run',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'energetic',
        'format': 'audio',
        'hour': 18,
        'minute': 0,
        'startDaysAgo': 27,
      },
      {
        'id': 'goal_005',
        'title': 'Journaling',
        'pillar': 'Personal Growth',
        'motivationStyle': 'reflective',
        'format': 'text',
        'hour': 21,
        'minute': 0,
        'startDaysAgo': 15,
      },
      {
        'id': 'goal_006',
        'title': 'Cold Shower',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'bold',
        'format': 'text',
        'hour': 7,
        'minute': 0,
        'startDaysAgo': 10,
      },
      {
        'id': 'goal_007',
        'title': 'Sales Follow-ups',
        'pillar': 'Business & Money',
        'motivationStyle': 'driven',
        'format': 'text',
        'hour': 10,
        'minute': 0,
        'startDaysAgo': 22,
      },
      {
        'id': 'goal_008',
        'title': 'Gratitude Practice',
        'pillar': 'Personal Growth',
        'motivationStyle': 'faith',
        'format': 'text',
        'hour': 6,
        'minute': 30,
        'startDaysAgo': 18,
      },
      {
        'id': 'goal_009',
        'title': 'Drink 3L Water',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'calm',
        'format': 'text',
        'hour': 7,
        'minute': 30,
        'startDaysAgo': 29,
      },
      {
        'id': 'goal_010',
        'title': 'Budget Check',
        'pillar': 'Business & Money',
        'motivationStyle': 'analytical',
        'format': 'text',
        'hour': 20,
        'minute': 0,
        'startDaysAgo': 12,
      },
      {
        'id': 'goal_011',
        'title': 'Stretching Routine',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'calm',
        'format': 'audio',
        'hour': 7,
        'minute': 0,
        'startDaysAgo': 8,
      },
      {
        'id': 'goal_012',
        'title': 'Learn New Skill',
        'pillar': 'Personal Growth',
        'motivationStyle': 'motivational',
        'format': 'text',
        'hour': 19,
        'minute': 0,
        'startDaysAgo': 14,
      },
      {
        'id': 'goal_013',
        'title': 'Prayer & Devotion',
        'pillar': 'Faith',
        'motivationStyle': 'faith',
        'format': 'text',
        'hour': 5,
        'minute': 30,
        'startDaysAgo': 29,
      },
      {
        'id': 'goal_014',
        'title': 'Network Outreach',
        'pillar': 'Business & Money',
        'motivationStyle': 'driven',
        'format': 'text',
        'hour': 11,
        'minute': 0,
        'startDaysAgo': 7,
      },
      {
        'id': 'goal_015',
        'title': 'Healthy Breakfast',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'calm',
        'format': 'text',
        'hour': 7,
        'minute': 0,
        'startDaysAgo': 29,
      },
      {
        'id': 'goal_016',
        'title': 'Weekly Planning',
        'pillar': 'Personal Growth',
        'motivationStyle': 'analytical',
        'format': 'text',
        'hour': 17,
        'minute': 0,
        'startDaysAgo': 21,
      },
      {
        'id': 'goal_017',
        'title': 'Podcast Learning',
        'pillar': 'Personal Growth',
        'motivationStyle': 'motivational',
        'format': 'audio',
        'hour': 12,
        'minute': 0,
        'startDaysAgo': 5,
      },
      {
        'id': 'goal_018',
        'title': 'Evening Walk',
        'pillar': 'Health & Fitness',
        'motivationStyle': 'calm',
        'format': 'text',
        'hour': 19,
        'minute': 30,
        'startDaysAgo': 16,
      },
      {
        'id': 'goal_019',
        'title': 'Savings Transfer',
        'pillar': 'Business & Money',
        'motivationStyle': 'driven',
        'format': 'text',
        'hour': 9,
        'minute': 0,
        'startDaysAgo': 3,
      },
      {
        'id': 'goal_020',
        'title': 'Digital Detox Hour',
        'pillar': 'Personal Growth',
        'motivationStyle': 'reflective',
        'format': 'text',
        'hour': 21,
        'minute': 30,
        'startDaysAgo': 11,
      },
    ];

    int count = 0;

    for (final goal in fakeGoals) {
      final startDaysAgo = goal['startDaysAgo'] as int;

      // ✅ Only generate from goal's start date up to TODAY (never future)
      for (int daysAgo = startDaysAgo; daysAgo >= 0; daysAgo--) {
        final day = now.subtract(Duration(days: daysAgo));
        final dateKey = OccurrenceService.toDateKey(day);

        // ✅ Hard guard — never create future occurrences
        if (dateKey.compareTo(today) > 0) continue;

        final status = _fakeStatus(daysAgo, goal['id'] as String);

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
                  0,
                )
              : null,
          pillar: goal['pillar'] as String,
          motivationStyle: goal['motivationStyle'] as String,
          format: goal['format'] as String,
        );

        await box.add(occurrence);
        count++;
      }
    }

    print('✅ Seeded $count fake occurrences for 20 goals');
  }

  /// Realistic completion patterns per goal
  static GoalOccurrenceStatus _fakeStatus(int daysAgo, String goalId) {
    // Today always pending so you can test buttons
    if (daysAgo == 0) return GoalOccurrenceStatus.pending;

    // Each goal has its own completion rate
    final rates = {
      'goal_001': 0.90, // Morning Meditation — very consistent
      'goal_002': 0.75, // Read 10 Pages
      'goal_003': 0.50, // Revenue Review
      'goal_004': 0.80, // Evening Run
      'goal_005': 0.65, // Journaling
      'goal_006': 0.55, // Cold Shower — hard habit
      'goal_007': 0.60, // Sales Follow-ups
      'goal_008': 0.85, // Gratitude Practice
      'goal_009': 0.70, // Drink 3L Water
      'goal_010': 0.45, // Budget Check
      'goal_011': 0.60, // Stretching
      'goal_012': 0.50, // Learn New Skill
      'goal_013': 0.95, // Prayer — very consistent
      'goal_014': 0.40, // Network Outreach — tough
      'goal_015': 0.80, // Healthy Breakfast
      'goal_016': 0.55, // Weekly Planning
      'goal_017': 0.70, // Podcast Learning
      'goal_018': 0.65, // Evening Walk
      'goal_019': 0.85, // Savings Transfer
      'goal_020': 0.35, // Digital Detox — hardest
    };

    final rate = rates[goalId] ?? 0.65;
    final seed = (daysAgo * goalId.hashCode).abs() % 100;
    final threshold = (rate * 100).round();

    if (seed < threshold) return GoalOccurrenceStatus.completed;
    if (seed < threshold + 8) return GoalOccurrenceStatus.skipped;
    return GoalOccurrenceStatus.pending; // missed
  }

  /// Wipe everything and re-seed fresh
  static Future<void> resetAndReseed() async {
    final box = Hive.box<GoalOccurrence>('goal_occurrences');
    await box.clear();
    print('🗑️ Cleared all occurrences');
    await seedFakeOccurrences();
  }
}
