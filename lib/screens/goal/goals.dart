import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/controllers/pillar_controller.dart';
import 'package:rosary/route/route_helpers.dart';
import '../../controllers/goal_controller.dart';
import '../../controllers/user_controller.dart';
import '../../enums/pillar_type.dart';
import '../../model/goal_model.dart';

class GoalsPage extends StatelessWidget {
  GoalsPage({super.key});

  final UserController userController = Get.find<UserController>();
  final GoalController goalController = Get.find<GoalController>();
  final PillarController pillarController = Get.find<PillarController>();

  @override
  Widget build(BuildContext context) {
    goalController.loadGoals();

    return Scaffold(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          final goals = goalController.goals;

          if (goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flag_outlined,
                      size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    "No goals yet.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap + to create your first goal",
                    style: TextStyle(fontSize: 14, color: Colors.white38),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: goals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = goals[index];
              return _GoalCard(
                goal: goal,
                onEdit: () {
                  goalController.setGoal(goal);
                  Get.toNamed(RouteHelpers.editGoalPage);
                },
                onDelete: () => _confirmDelete(context, goal),
                onToggleActive: () => _toggleActive(goal),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B82FF),
        onPressed: () {
          pillarController.setSelectedPillars(
            (userController.user.value?.focusPillars ?? [])
                .map((s) => pillarFromApi(s))
                .toList(),
          );
          Get.toNamed(RouteHelpers.newGoalPage);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Toggle active/paused
  // ─────────────────────────────────────────
  Future<void> _toggleActive(GoalModel goal) async {
    final updated = goal.copyWith(active: !(goal.active ?? true));
    print(updated.active);
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

// ─────────────────────────────────────────
// Goal Card with Edit / Delete / Toggle
// ─────────────────────────────────────────
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
          // ── Top row: title + action buttons ──
          Row(
            children: [
              // Pillar color dot
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pillar.color,
                ),
              ),
              const SizedBox(width: 8),

              // Title
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

              // ── Edit button ──
              _ActionIcon(
                icon: Icons.edit_rounded,
                color: const Color(0xFF7B82FF),
                onTap: onEdit,
                tooltip: "Edit",
              ),

              const SizedBox(width: 4),

              // ── Pause / Resume button ──
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

              // ── Delete button ──
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
              // Pillar label
              _MetaChip(
                icon: pillar.icon,
                label: pillar.label,
                color: pillar.color,
              ),
              const SizedBox(width: 8),

              // Repeat type
              _MetaChip(
                icon: Icons.repeat_rounded,
                label: _repeatLabel(goal.repeatType),
                color: const Color(0xFF7B82FF),
              ),
              const SizedBox(width: 8),

              // Time
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
              // Active/Paused badge
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

              // Streak
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

// ─────────────────────────────────────────
// Action Icon Button
// ─────────────────────────────────────────
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

// ─────────────────────────────────────────
// Meta Chip (pillar, repeat, time)
// ─────────────────────────────────────────
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
