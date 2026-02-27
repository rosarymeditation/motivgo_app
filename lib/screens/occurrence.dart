
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/controllers/goal_controller.dart';
import 'package:rosary/widgets/goal_card_widget.dart';
import '../model/goal_model.dart';
import '../model/goal_occurrence_model.dart';
import '../service/occurrence_service.dart';
class GoalOccurrencePage extends StatelessWidget {
  const GoalOccurrencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GoalController goalController = Get.find<GoalController>();
    goalController.loadGoalOccurences();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1C3D),
        appBar: AppBar(
          title: const Text(
            "MotivGo",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color(0xFF2B2E5A),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Color(0xFF7B82FF),
            indicatorWeight: 3,
            labelColor: Color(0xFF7B82FF),
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: "Today's Goals"),
              Tab(text: "All Goals"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TodayOccurrencesTab(goalController: goalController),
            _AllGoalsTab(goalController: goalController),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF7B82FF),
          onPressed: () {
            // TODO: Navigate to add new goal page
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TAB 1: Today's Occurrences
// ─────────────────────────────────────────
class _TodayOccurrencesTab extends StatelessWidget {
  final GoalController goalController;
  const _TodayOccurrencesTab({required this.goalController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final allOccurrences = goalController.goalOccurences.toList()
        ..sort((a, b) => b.dateKey.compareTo(a.dateKey)); // newest first

      if (allOccurrences.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 64, color: Colors.white24),
              const SizedBox(height: 16),
              const Text(
                "No goals scheduled yet",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        );
      }

      // Today's occurrences for progress bar
      final todayKey = OccurrenceService.toDateKey(DateTime.now());
      final todayOccurrences =
          allOccurrences.where((o) => o.dateKey == todayKey).toList();
      final completed = todayOccurrences
          .where((o) => o.status == GoalOccurrenceStatus.completed)
          .length;
      final total = todayOccurrences.length;
      final progress = total == 0 ? 0.0 : completed / total;

      return Column(
        children: [
          // ── Progress Header ──
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2E5A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Progress",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      "$completed / $total completed",
                      style: const TextStyle(
                          color: Color(0xFF7B82FF), fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white12,
                    color: const Color(0xFF7B82FF),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // ── Full Occurrence List (all days) ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: allOccurrences.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final occurrence = allOccurrences[index];
                return _OccurrenceCard(
                  occurrence: occurrence,
                  goalController: goalController,
                  goals: goalController.goals,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────
// Occurrence Card
// ─────────────────────────────────────────
class _OccurrenceCard extends StatelessWidget {
  final GoalOccurrence occurrence;
  final GoalController goalController;
  final List<GoalModel> goals;

  const _OccurrenceCard({
    required this.occurrence,
    required this.goalController,
    required this.goals,
  });

  // ── Expired = dateKey is before today ──
  bool get _isExpired {
    final today = OccurrenceService.toDateKey(DateTime.now());
    return occurrence.dateKey.compareTo(today) < 0;
  }

  Color get _statusColor {
    if (_isExpired && occurrence.status == GoalOccurrenceStatus.pending) {
      return Colors.white24;
    }
    switch (occurrence.status) {
      case GoalOccurrenceStatus.completed:
        return const Color(0xFF4CAF50);
      case GoalOccurrenceStatus.skipped:
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF7B82FF);
    }
  }

  IconData get _statusIcon {
    if (_isExpired && occurrence.status == GoalOccurrenceStatus.pending) {
      return Icons.lock_clock;
    }
    switch (occurrence.status) {
      case GoalOccurrenceStatus.completed:
        return Icons.check_circle;
      case GoalOccurrenceStatus.skipped:
        return Icons.cancel;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  String get _statusLabel {
    if (_isExpired && occurrence.status == GoalOccurrenceStatus.pending) {
      return "Missed";
    }
    switch (occurrence.status) {
      case GoalOccurrenceStatus.completed:
        return "Completed";
      case GoalOccurrenceStatus.skipped:
        return "Skipped";
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = occurrence.status == GoalOccurrenceStatus.pending;
    final expired = _isExpired;
    final goal = goals.firstWhereOrNull((g) => g.id == occurrence.goalId);
    final today = OccurrenceService.toDateKey(DateTime.now());
    final isToday = occurrence.dateKey == today;

    return Container(
      decoration: BoxDecoration(
        color: expired
            ? const Color(0xFF1E2040) // dimmed for expired
            : const Color(0xFF2B2E5A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: expired ? Colors.white12 : _statusColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + Status Badge ──
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      occurrence.goalTitle ?? "Untitled Goal",
                      style: TextStyle(
                        color: expired ? Colors.white38 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Date label
                    Text(
                      isToday ? "Today" : _formatDate(occurrence.dateKey),
                      style: TextStyle(
                        color: isToday
                            ? const Color(0xFF7B82FF)
                            : Colors.white24,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: expired && isPending
                      ? Colors.white10
                      : _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon, color: _statusColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Pillar + Time ──
          Row(
            children: [
              const Icon(Icons.schedule, size: 13, color: Colors.white38),
              const SizedBox(width: 4),
              Text(
                _formatTime(occurrence.scheduledAt),
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              if (occurrence.pillar != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.category, size: 13, color: Colors.white38),
                const SizedBox(width: 4),
                Text(
                  occurrence.pillar!,
                  style:
                      const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ],
          ),

          // ── Action Buttons — today + pending only ──
          if (isPending && !expired) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: goal == null
                        ? null
                        : () async {
                            await OccurrenceService.markCompleted(
                                occurrence, goal);
                            goalController.loadGoalOccurences();
                          },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text("Complete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: goal == null
                        ? null
                        : () async {
                            await OccurrenceService.markSkipped(
                                occurrence, goal);
                            goalController.loadGoalOccurences();
                          },
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text("Skip"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9800),
                      side: const BorderSide(color: Color(0xFFFF9800)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ── Missed message — past day + still pending ──
          if (isPending && expired) ...[
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.lock_clock, size: 13, color: Colors.white24),
                SizedBox(width: 6),
                Text(
                  "Missed — no action can be taken",
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
              ],
            ),
          ],

          // ── Checked In Time (if completed) ──
          if (occurrence.status == GoalOccurrenceStatus.completed &&
              occurrence.checkedInAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.done_all,
                    size: 13, color: Color(0xFF4CAF50)),
                const SizedBox(width: 4),
                Text(
                  "Checked in at ${_formatTime(occurrence.checkedInAt!)}",
                  style: const TextStyle(
                      color: Color(0xFF4CAF50), fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatDate(String dateKey) {
    try {
      final parts = dateKey.split('-');
      final dt = DateTime(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      return dateKey;
    }
  }
}

// ─────────────────────────────────────────
// TAB 2: All Goals
// ─────────────────────────────────────────
class _AllGoalsTab extends StatelessWidget {
  final GoalController goalController;
  const _AllGoalsTab({required this.goalController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final goals = goalController.goals;

      if (goals.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.flag_outlined, size: 64, color: Colors.white24),
              SizedBox(height: 16),
              Text(
                "No goals yet. Tap + to add one!",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: goals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final goal = goals[index];
          return GoalCardWidget(goal: goal, goalController: goalController);
        },
      );
    });
  }
}

// ─────────────────────────────────────────
// Goal Card
// ─────────────────────────────────────────


// ─────────────────────────────────────────
// Status Pill
// ─────────────────────────────────────────

