import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rosary/controllers/pillar_controller.dart';
import 'package:rosary/route/route_helpers.dart';
import 'package:rosary/widgets/caption.dart';
import '../../controllers/goal_controller.dart';
import '../../controllers/user_controller.dart';
import '../enums/pillar_type.dart';
import '../model/goal_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  final UserController _userController = Get.find<UserController>();
  final PillarController _pillarController = Get.find<PillarController>();
  final GoalController _goalController = Get.find<GoalController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ✅ watch app lifecycle
    _pillarController.setIsForFirstGoal(false);
    _goalController.loadGoals(); // ✅ fresh load on open
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ Reload goals when app comes back to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _goalController.loadGoals();
    }
  }

  // ─────────────────────────────────────────
  // Compute next upcoming goal reactively
  // ─────────────────────────────────────────
  GoalModel? _getNextGoal(List<GoalModel> goals) {
    final now = DateTime.now();
    GoalModel? nearest;
    DateTime? nearestTime;

    for (final goal in goals) {
      if (!(goal.active ?? true)) continue; // skip paused goals
      if (goal.hour == null || goal.minute == null) continue;

      final next = _nextOccurrence(goal, now);
      if (next == null) continue;

      if (nearestTime == null || next.isBefore(nearestTime)) {
        nearestTime = next;
        nearest = goal;
      }
    }

    return nearest;
  }

  DateTime? _nextOccurrence(GoalModel goal, DateTime now) {
    final h = goal.hour!;
    final m = goal.minute!;

    switch (goal.repeatType) {
      case 'weekly':
        if (goal.weekdays == null || goal.weekdays!.isEmpty) return null;
        // Find closest upcoming weekday
        for (int i = 0; i <= 7; i++) {
          final candidate = DateTime(now.year, now.month, now.day, h, m)
              .add(Duration(days: i));
          if (candidate.isAfter(now) &&
              goal.weekdays!.contains(candidate.weekday)) {
            return candidate;
          }
        }
        return null;

      case 'monthly':
        final day = goal.dayOfMonth;
        if (day == null) return null;
        var candidate = DateTime(now.year, now.month, day, h, m);
        if (candidate.isBefore(now)) {
          candidate = DateTime(now.year, now.month + 1, day, h, m);
        }
        return candidate;

      case 'yearly':
        if (goal.scheduledAt == null) return null;
        var candidate = DateTime(
            now.year, goal.scheduledAt!.month, goal.scheduledAt!.day, h, m);
        if (candidate.isBefore(now)) {
          candidate = DateTime(now.year + 1, goal.scheduledAt!.month,
              goal.scheduledAt!.day, h, m);
        }
        return candidate;

      case 'none':
      default:
        if (goal.scheduledAt == null) return null;
        final candidate = DateTime(
          goal.scheduledAt!.year,
          goal.scheduledAt!.month,
          goal.scheduledAt!.day,
          h,
          m,
        );
        return candidate.isAfter(now) ? candidate : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E1330);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 28,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 0.6,
                  child: const Image(
                    image: AssetImage("assets/images/background_two.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Greeting ──
                      Center(
                        child: Obx(() => Text(
                              _userController.getGreeting(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            )),
                      ),

                      const SizedBox(height: 30),

                      // ── Next Goal Card — fully reactive ──
                      Obx(() {
                        final goals = _goalController.goals;
                        final nextGoal = _getNextGoal(goals);

                        if (nextGoal == null) return _emptyState();

                        final now = DateTime.now();
                        final nextTime = _nextOccurrence(nextGoal, now);
                        if (nextTime == null) return _emptyState();

                        final diff = nextTime.difference(now);
                        final minutesLeft = diff.inMinutes;
                        final hoursLeft = diff.inHours;

                        final formattedTime =
                            "${nextTime.hour.toString().padLeft(2, '0')}:${nextTime.minute.toString().padLeft(2, '0')}";

                        final pillar =
                            pillarFromApi(nextGoal.pillar ?? 'personal_growth');

                        return _GlassSection(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: pillar.color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(pillar.icon,
                                        color: pillar.color, size: 26),
                                  ),
                                ),

                                const SizedBox(width: 4),

                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nextGoal.title ?? '',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF2B2E5A),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "$formattedTime  ·  ${pillar.label}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF7A7FA8),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Countdown pill
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: pillar.color.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 12,
                                              color: pillar.color,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _buildCountdownText(
                                                  minutesLeft, hoursLeft),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: pillar.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // ── All active goals mini list ──
                      Obx(() {
                       final active = _goalController.goals
                            .where((g) => g.active ?? true)
                            .take(3)
                            .toList();

                        if (active.isEmpty) return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Active Goals",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...active.map((goal) => _MiniGoalRow(goal: goal)),
                          ],
                        );
                      }),

                      const SizedBox(height: 30),

                      // ── Add Goal Button ──
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _pillarController.setSelectedPillars(
                              (_userController.user.value?.focusPillars ?? [])
                                  .map((s) => pillarFromApi(s))
                                  .toList(),
                            );
                            Get.toNamed(RouteHelpers.newGoalPage);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B2E5A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Add New Goal",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── View History ──
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white.withOpacity(0.08),
                        ),
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.favorite,
                                      color: Colors.white54, size: 18),
                                  SizedBox(width: 10),
                                  Text(
                                    "View All Goals",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(
                                    RouteHelpers.goalOccurrencePage),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(0.12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.stacked_bar_chart,
                                          color: Colors.white70, size: 16),
                                      SizedBox(width: 6),
                                      Text(
                                        "History & Insights",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: const [
          Icon(Icons.flag_outlined, color: Colors.white24, size: 40),
          SizedBox(height: 12),
          Text(
            "No upcoming goals.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Tap 'Add New Goal' to get started.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  String _buildCountdownText(int minutesLeft, int hoursLeft) {
    if (minutesLeft <= 0) return "Starting now";
    if (hoursLeft >= 24)
      return "In ${hoursLeft ~/ 24} day${hoursLeft ~/ 24 > 1 ? 's' : ''}";
    if (hoursLeft >= 1) return "In $hoursLeft hour${hoursLeft > 1 ? 's' : ''}";
    return "In $minutesLeft min${minutesLeft > 1 ? 's' : ''}";
  }
}

// ─────────────────────────────────────────
// Mini Goal Row — shown in active goals list
// ─────────────────────────────────────────
class _MiniGoalRow extends StatelessWidget {
  final GoalModel goal;
  const _MiniGoalRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    final pillar = pillarFromApi(goal.pillar ?? 'personal_growth');
    final h = goal.hour ?? 0;
    final m = goal.minute ?? 0;
    final hour = h % 12 == 0 ? 12 : h % 12;
    final minute = m.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pillar.color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              goal.title ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
          Text(
            "$hour:$minute $period",
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Glass Section
// ─────────────────────────────────────────
class _GlassSection extends StatelessWidget {
  final Widget child;
  const _GlassSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
