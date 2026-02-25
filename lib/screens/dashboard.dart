import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rosary/route/route_helpers.dart';
import 'package:rosary/widgets/caption.dart';
import '../../controllers/user_controller.dart';
import '../enums/pillar_type.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final UserController _userController = Get.find<UserController>();

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
                      /// 🔹 Header
                      Center(
                        child: Text(
                          _userController.getGreeting(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// 🔹 Next Goal Card
                      Obx(() {
                        final goal = _userController.goal.value;

                        if (goal == null) return _emptyState();

                        final nextOccurrence =
                            _userController.getNextOccurrence(goal);
                        if (nextOccurrence == null) return _emptyState();

                        final now = DateTime.now();
                        final diff = nextOccurrence.difference(now);
                        final minutesLeft = diff.inMinutes;
                        final hoursLeft = diff.inHours;

                        final formattedTime =
                            "${nextOccurrence.hour.toString().padLeft(2, '0')}:${nextOccurrence.minute.toString().padLeft(2, '0')}";

                        final pillar =
                            pillarFromApi(goal.pillar ?? "health_fitness");

                        return _GlassSection(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.18,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/power.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal.title ?? "",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF2B2E5A),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "$formattedTime | ${pillar.label}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF7A7FA8),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _buildCountdownText(
                                          minutesLeft, hoursLeft),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2B2E5A),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 40),

                      /// 🔹 Add Goal Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Add Goal Page
                            // Get.toNamed(RouteHelpers.addGoal);
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

                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.grey.shade200),
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.favorite),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  MotivGoCaption("View All Goals"),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(RouteHelpers.goalOccurrencePage),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.stacked_bar_chart),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text("View history & Insights"),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
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

  /// 🔹 Empty State Widget
  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        "No upcoming goal.\nCreate one to stay consistent.",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7A7FA8),
        ),
      ),
    );
  }

  /// 🔹 Countdown Formatting
  String _buildCountdownText(int minutesLeft, int hoursLeft) {
    if (minutesLeft <= 0) return "Starting soon";
    if (hoursLeft >= 1) return "In $hoursLeft hour${hoursLeft > 1 ? "s" : ""}";
    return "In $minutesLeft min${minutesLeft > 1 ? "s" : ""}";
  }
}

class _GlassSection extends StatelessWidget {
  final Widget child;

  const _GlassSection({
    required this.child,
  });

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
              // Row(
              //   children: [
              //     Text(
              //       title,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w900,
              //         color: Colors.white.withOpacity(0.92),
              //       ),
              //     ),
              //     const Spacer(),
              //     if (trailing != null) trailing!,
              //   ],
              // ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
