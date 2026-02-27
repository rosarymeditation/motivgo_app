// lib/controllers/insight_controller.dart

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rosary/utils/hive_storage.dart';
import '../model/goal_occurrence_model.dart';
import '../service/occurrence_service.dart';

class InsightController extends GetxController {
  // ── Reactive state ──
  final weeklyValues = <double>[].obs; // 7 bar heights (0.0–1.0)
  final weeklyLabels = <String>[].obs; // ["M","T","W"...]
  final streakDays = 0.obs;
  final consistency = 0.obs; // percentage
  final focusAreas = <String, double>{}.obs; // pillar → fraction
  final consistencyPoints = <double>[].obs; // 30 normalized y-values

  @override
  void onInit() {
    super.onInit();
    loadInsights();
  }

  void loadInsights() {
    final occBox = Hive.box<GoalOccurrence>(HiveStorage.goalOccurrenceBox);
    final allOccurrences = occBox.values.toList();

    _computeWeeklyRecap(allOccurrences);
    _computeFocusAreas(allOccurrences);
    _computeConsistency(allOccurrences);
    _computeStreak(allOccurrences);
  }

  // ─────────────────────────────────────────
  // Weekly Recap — last 7 days completion %
  // ─────────────────────────────────────────
  void _computeWeeklyRecap(List<GoalOccurrence> all) {
    final now = DateTime.now();
    final labels = <String>[];
    final values = <double>[];
    const dayLabels = ["M", "T", "W", "T", "F", "S", "S"];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dateKey = OccurrenceService.toDateKey(day);
      final dayOcc = all.where((o) => o.dateKey == dateKey).toList();

      final total = dayOcc.length;
      final done = dayOcc
          .where((o) => o.status == GoalOccurrenceStatus.completed)
          .length;

      values.add(total == 0 ? 0.0 : done / total);
      labels.add(dayLabels[day.weekday - 1]);
    }

    weeklyValues.value = values;
    weeklyLabels.value = labels;
  }

  // ─────────────────────────────────────────
  // Focus Areas — completion % per pillar
  // ─────────────────────────────────────────
  void _computeFocusAreas(List<GoalOccurrence> all) {
    final Map<String, int> totalMap = {};
    final Map<String, int> doneMap = {};

    for (final o in all) {
      final pillar = o.pillar ?? "Other";
      totalMap[pillar] = (totalMap[pillar] ?? 0) + 1;
      if (o.status == GoalOccurrenceStatus.completed) {
        doneMap[pillar] = (doneMap[pillar] ?? 0) + 1;
      }
    }

    final totalAll = all.length;
    if (totalAll == 0) {
      focusAreas.value = {};
      return;
    }

    // Fraction of total occurrences per pillar
    final result = <String, double>{};
    for (final pillar in totalMap.keys) {
      result[pillar] = (totalMap[pillar] ?? 0) / totalAll;
    }

    focusAreas.value = result;
  }

  // ─────────────────────────────────────────
  // 30-Day Consistency — daily % for line chart
  // ─────────────────────────────────────────
  void _computeConsistency(List<GoalOccurrence> all) {
    final now = DateTime.now();
    final points = <double>[];
    int totalDone = 0;
    int totalAll = 0;

    for (int i = 29; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dateKey = OccurrenceService.toDateKey(day);
      final dayOcc = all.where((o) => o.dateKey == dateKey).toList();

      final done = dayOcc
          .where((o) => o.status == GoalOccurrenceStatus.completed)
          .length;

      totalDone += done;
      totalAll += dayOcc.length;

      // Normalize: 0 = bottom (0%), 1 = top (100%) → invert for chart
      final rate = dayOcc.isEmpty ? 0.0 : done / dayOcc.length;
      points.add(1.0 - rate); // invert so high = visually high
    }

    consistencyPoints.value = points;
    consistency.value =
        totalAll == 0 ? 0 : ((totalDone / totalAll) * 100).round();
  }

  // ─────────────────────────────────────────
  // Streak — consecutive days with ≥1 completed
  // ─────────────────────────────────────────
  void _computeStreak(List<GoalOccurrence> all) {
    int streak = 0;
    final now = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final day = now.subtract(Duration(days: i));
      final dateKey = OccurrenceService.toDateKey(day);
      final dayOcc = all.where((o) => o.dateKey == dateKey).toList();

      final hasCompleted =
          dayOcc.any((o) => o.status == GoalOccurrenceStatus.completed);

      if (hasCompleted) {
        streak++;
      } else if (i > 0) {
        // Allow today to be pending
        break;
      }
    }

    streakDays.value = streak;
  }
}
