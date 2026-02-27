import 'package:flutter/material.dart';

import '../controllers/goal_controller.dart';
import '../enums/pillar_type.dart';
import '../model/goal_model.dart';
import '../model/goal_occurrence_model.dart';
import '../service/occurrence_service.dart';
import '../utils/constants.dart';

class GoalCardWidget extends StatelessWidget {
  final GoalModel goal;
  final GoalController goalController;

  const GoalCardWidget({required this.goal, required this.goalController});

  @override
  Widget build(BuildContext context) {
    final pillar = pillarFromApi(goal.pillar ?? "health_fitness");
    final scheduledTime = goal.scheduledAt ??
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          goal.hour ?? 0,
          goal.minute ?? 0,
        );

    final todayOccurrence = goalController.goalOccurences
        .where((o) =>
            o.goalId == goal.id &&
            o.dateKey == OccurrenceService.toDateKey(DateTime.now()))
        .firstOrNull;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2E5A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // ── Icon ──
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flag, color: Color(0xFF7B82FF)),
          ),
          const SizedBox(width: 12),

          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title ?? "Untitled",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${AppConstant.formatGoalTime(scheduledTime)} · ${pillar.label} · ${_repeatLabel(goal.repeatType)}",
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                if (todayOccurrence != null) ...[
                  const SizedBox(height: 6),
                  _StatusPill(status: todayOccurrence.status),
                ],
              ],
            ),
          ),

          // ── Active toggle ──
          Icon(
            goal.active == true ? Icons.check_circle : Icons.pause_circle,
            color: goal.active == true ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  String _repeatLabel(String? repeatType) {
    switch (repeatType) {
      case "weekly":
        return "Weekly";
      case "monthly":
        return "Monthly";
      case "yearly":
        return "Yearly";
      default:
        return "One-time";
    }
  }
}
class _StatusPill extends StatelessWidget {
  final GoalOccurrenceStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case GoalOccurrenceStatus.completed:
        color = const Color(0xFF4CAF50);
        label = "Done today";
        icon = Icons.check_circle;
        break;
      case GoalOccurrenceStatus.skipped:
        color = const Color(0xFFFF9800);
        label = "Skipped today";
        icon = Icons.cancel;
        break;
      default:
        color = const Color(0xFF7B82FF);
        label = "Pending";
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
