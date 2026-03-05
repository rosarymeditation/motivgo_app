import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivgo/controllers/pillar_controller.dart';
import 'package:motivgo/route/route_helpers.dart';
import '../../controllers/goal_controller.dart';
import '../../controllers/user_controller.dart';
import '../../enums/pillar_type.dart';
import '../../model/goal_model.dart';
import '../../model/goal_occurrence_model.dart';
import '../../service/occurrence_service.dart';

class GoalsPage extends StatelessWidget {
  GoalsPage({super.key});

  final UserController userController = Get.find<UserController>();
  final GoalController goalController = Get.find<GoalController>();
  final PillarController pillarController = Get.find<PillarController>();

  @override
  Widget build(BuildContext context) {
    goalController.loadGoals();
    goalController.loadGoalOccurences();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1C3D),
        appBar: AppBar(
          title: const Text(
            "Your Goals",
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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
            tabs: [
              Tab(icon: Icon(Icons.flag_rounded, size: 18), text: "Goals"),
              Tab(
                  icon: Icon(Icons.history_rounded, size: 18),
                  text: "Occurrences"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ── Tab 1: Goals ──
            _GoalsTab(
              goalController: goalController,
              onEdit: (goal) {
                goalController.setGoal(goal);
                Get.toNamed(RouteHelpers.editGoalPage);
              },
              onDelete: (goal) => _confirmDelete(context, goal),
              onToggleActive: (goal) => _toggleActive(goal),
            ),

            // ── Tab 2: Occurrences ──
            _OccurrencesTab(goalController: goalController),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF7B82FF),
          onPressed: () {
            pillarController.setSelectedPillars(
              (userController.user.value?.focusPillars ?? [])
                  .map((s) => pillarFromApi(s))
                  .toList(),
            );
            // ✅ Go to focus page first
            Get.toNamed(RouteHelpers.focusAreaPage);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Toggle active/paused
  // ─────────────────────────────────────────
  Future<void> _toggleActive(GoalModel goal) async {
    final updated = goal.copyWith(active: !(goal.active ?? true));
    await goalController.updateGoal(updated);
  }

  // ─────────────────────────────────────────
  // Confirm delete
  // ─────────────────────────────────────────
  void _confirmDelete(BuildContext context, GoalModel goal) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1C3D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.delete_forever_rounded,
                color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Delete Goal?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${goal.title}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B82FF),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This will remove the goal and all its history.\nThis cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await goalController.deleteGoal(goal);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Yes, Delete",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// ═══════════════════════════════════════════
// TAB 1 — Goals
// ═══════════════════════════════════════════

class _GoalsTab extends StatelessWidget {
  final GoalController goalController;
  final void Function(GoalModel) onEdit;
  final void Function(GoalModel) onDelete;
  final void Function(GoalModel) onToggleActive;

  const _GoalsTab({
    required this.goalController,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final goals = goalController.goals;

      if (goals.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag_outlined, size: 64, color: Colors.white24),
              SizedBox(height: 16),
              Text(
                "No goals yet.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Tap + to create your first goal",
                style: TextStyle(fontSize: 14, color: Colors.white38),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        itemCount: goals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final goal = goals[index];
          return _GoalCard(
            goal: goal,
            onEdit: () => onEdit(goal),
            onDelete: () => onDelete(goal),
            onToggleActive: () => onToggleActive(goal),
          );
        },
      );
    });
  }
}

// ═══════════════════════════════════════════
// TAB 2 — Occurrences
// ═══════════════════════════════════════════

class _OccurrencesTab extends StatelessWidget {
  final GoalController goalController;

  const _OccurrencesTab({required this.goalController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final occurrences = goalController.goalOccurences;

      if (occurrences.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_toggle_off_rounded,
                  size: 64, color: Colors.white24),
              SizedBox(height: 16),
              Text(
                "No occurrences yet.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Occurrences appear after your goals trigger",
                style: TextStyle(fontSize: 14, color: Colors.white38),
              ),
            ],
          ),
        );
      }

      // ✅ Sort newest first
      final sorted = occurrences.toList()
        ..sort((a, b) => (b.dateKey ?? '').compareTo(a.dateKey ?? ''));

      // ✅ Group by dateKey
      final Map<String, List<GoalOccurrence>> grouped = {};
      for (final occ in sorted) {
        final key = occ.dateKey ?? 'Unknown';
        grouped.putIfAbsent(key, () => []).add(occ);
      }

      final dateKeys = grouped.keys.toList();

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        itemCount: dateKeys.length,
        itemBuilder: (context, i) {
          final dateKey = dateKeys[i];
          final dayOccurrences = grouped[dateKey]!;
          final isToday = dateKey == _todayKey();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Date header ──
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isToday
                            ? const Color(0xFF7B82FF).withOpacity(0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isToday ? "Today  ·  $dateKey" : dateKey,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isToday
                              ? const Color(0xFF7B82FF)
                              : Colors.white38,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(color: Colors.white12, height: 1),
                    ),
                  ],
                ),
              ),

              // ── Occurrences for this date ──
              ...dayOccurrences.map((occ) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _OccurrenceCard(
                      occurrence: occ,
                      goalController: goalController,
                    ),
                  )),

              const SizedBox(height: 4),
            ],
          );
        },
      );
    });
  }

  String _todayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}

// ═══════════════════════════════════════════
// OCCURRENCE CARD
// ═══════════════════════════════════════════

class _OccurrenceCard extends StatelessWidget {
  final GoalOccurrence occurrence;
  final GoalController goalController;

  const _OccurrenceCard({
    required this.occurrence,
    required this.goalController,
  });

  String _todayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  bool get _isExpired => (occurrence.dateKey ?? '').compareTo(_todayKey()) < 0;

  bool get _isPending => occurrence.status == GoalOccurrenceStatus.pending;

  @override
  Widget build(BuildContext context) {
    final pillar = pillarFromApi(occurrence.pillar ?? 'personal_growth');

    final Color statusColor;
    final IconData statusIcon;
    final String statusLabel;

    switch (occurrence.status) {
      case GoalOccurrenceStatus.completed:
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.check_circle_rounded;
        statusLabel = "Completed";
        break;
      case GoalOccurrenceStatus.skipped:
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.skip_next_rounded;
        statusLabel = "Skipped";
        break;
      case GoalOccurrenceStatus.pending:
      default:
        statusColor = _isExpired ? Colors.white24 : const Color(0xFF7B82FF);
        statusIcon = _isExpired
            ? Icons.lock_clock
            : Icons.radio_button_unchecked_rounded;
        statusLabel = _isExpired ? "Missed" : "Pending";
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isExpired && _isPending
            ? const Color(0xFF1E2040)
            : const Color(0xFF2B2E5A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isExpired && _isPending
              ? Colors.white12
              : statusColor.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row ──
          Row(
            children: [
              // Status icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      occurrence.goalTitle ?? 'Untitled',
                      style: TextStyle(
                        color: _isExpired && _isPending
                            ? Colors.white38
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(pillar.icon,
                            size: 11, color: pillar.color.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        Text(
                          pillar.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: pillar.color.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (occurrence.scheduledAt != null) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.schedule_rounded,
                              size: 11, color: Colors.white38),
                          const SizedBox(width: 3),
                          Text(
                            _formatTime(occurrence.scheduledAt!),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white38,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          // ── Complete / Skip buttons — today + pending only ──
          if (_isPending && !_isExpired) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                // Complete
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final goal = goalController.goals
                          .firstWhereOrNull((g) => g.id == occurrence.goalId);
                      if (goal == null) return;
                      await OccurrenceService.markCompleted(occurrence, goal);
                      goalController.loadGoalOccurences();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded,
                              size: 16, color: Color(0xFF4CAF50)),
                          SizedBox(width: 6),
                          Text(
                            "Complete",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Skip
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final goal = goalController.goals
                          .firstWhereOrNull((g) => g.id == occurrence.goalId);
                      if (goal == null) return;
                      await OccurrenceService.markSkipped(occurrence, goal);
                      goalController.loadGoalOccurences();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF9800).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.skip_next_rounded,
                              size: 16, color: Color(0xFFFF9800)),
                          SizedBox(width: 6),
                          Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ── Expired message ──
          if (_isPending && _isExpired) ...[
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.lock_clock, size: 12, color: Colors.white24),
                SizedBox(width: 6),
                Text(
                  "Missed — no action can be taken",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          // ── Completed time ──
          if (occurrence.status == GoalOccurrenceStatus.completed &&
              occurrence.checkedInAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 12, color: Color(0xFF4CAF50)),
                const SizedBox(width: 6),
                Text(
                  "Checked in at ${_formatTime(occurrence.checkedInAt!)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

// ═══════════════════════════════════════════
// GOAL CARD
// ═══════════════════════════════════════════

class _GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  const _GoalCard({
    required this.goal,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final pillar = pillarFromApi(goal.pillar ?? 'personal_growth');
    final isActive = goal.active ?? true;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2E5A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? const Color(0xFF7B82FF).withOpacity(0.3)
              : Colors.white12,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row ──
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pillar.color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goal.title ?? 'Untitled',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              _ActionIcon(
                icon: Icons.edit_rounded,
                color: const Color(0xFF7B82FF),
                onTap: onEdit,
                tooltip: "Edit",
              ),
              const SizedBox(width: 4),
              _ActionIcon(
                icon: isActive
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                color: isActive
                    ? const Color(0xFFFF9800)
                    : const Color(0xFF4CAF50),
                onTap: onToggleActive,
                tooltip: isActive ? "Pause" : "Resume",
              ),
              const SizedBox(width: 4),
              _ActionIcon(
                icon: Icons.delete_outline_rounded,
                color: Colors.redAccent,
                onTap: onDelete,
                tooltip: "Delete",
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Meta row ──
          Row(
            children: [
              _MetaChip(
                  icon: pillar.icon, label: pillar.label, color: pillar.color),
              const SizedBox(width: 8),
              _MetaChip(
                icon: Icons.repeat_rounded,
                label: _repeatLabel(goal.repeatType),
                color: const Color(0xFF7B82FF),
              ),
              const SizedBox(width: 8),
              if (goal.hour != null && goal.minute != null)
                _MetaChip(
                  icon: Icons.schedule_rounded,
                  label: _formatTime(goal.hour!, goal.minute!),
                  color: Colors.white38,
                ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Status + streak row ──
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF4CAF50).withOpacity(0.15)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.pause_circle,
                      size: 12,
                      color:
                          isActive ? const Color(0xFF4CAF50) : Colors.white38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? "Active" : "Paused",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            isActive ? const Color(0xFF4CAF50) : Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if ((goal.currentStreak ?? 0) > 0) ...[
                const Icon(Icons.local_fire_department_rounded,
                    size: 14, color: Color(0xFFFF8A3D)),
                const SizedBox(width: 4),
                Text(
                  "${goal.currentStreak} day streak",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF8A3D),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _repeatLabel(String? repeatType) {
    switch (repeatType) {
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      case 'yearly':
        return 'Yearly';
      default:
        return 'One-time';
    }
  }

  String _formatTime(int hour, int minute) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

// ═══════════════════════════════════════════
// ACTION ICON
// ═══════════════════════════════════════════

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// META CHIP
// ═══════════════════════════════════════════

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
