import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/enums/pillar_type.dart';
import 'package:rosary/utils/constants.dart';

import '../controllers/user_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    // Match screenshot palette
    const bg = Color(0xFF0E1330);
    const glass = Color(0xB3FFFFFF);
    const textPrimary = Color(0xFFFFFFFF);
    const textSub = Color(0xD9FFFFFF);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                  // Background image (your exact asset)
                  const Image(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),

                  // Top dark overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Color(0xCC1A1F49),
                          Color(0x661A1F49),
                          Color(0x001A1F49),
                        ],
                      ),
                    ),
                  ),

                  // Bottom dark overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x001A1F49),
                          Color(0x661A1F49),
                          Color(0xCC1A1F49),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                    child: Column(
                      children: [
                        // Top bar: back + fake status spacing
                        Row(
                          children: [
                            // IconButton(
                            //   onPressed: () => Navigator.of(context).maybePop(),
                            //   icon:
                            //       const Icon(Icons.arrow_back_ios_new_rounded),
                            //   color: Colors.white.withOpacity(0.95),
                            // ),
                            const Spacer(),
                            const SizedBox(width: 44),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Obx(() {
                          final firstName =
                              _userController.user.value?.firstName ?? "";
                          return Text(
                            "Good morning, $firstName",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withOpacity(0.96),
                              letterSpacing: 0.2,
                            ),
                          );
                        }),
                        const SizedBox(height: 8),

                        Text(
                          "Your growth moment is coming soon.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.2,
                            fontWeight: FontWeight.w600,
                            color: textSub.withOpacity(0.82),
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Divider with dot
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 1,
                              width: 120,
                              color: Colors.white.withOpacity(0.18),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.55),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 1,
                              width: 120,
                              color: Colors.white.withOpacity(0.18),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Big glass card
                        _GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "“  Your growth moment is coming up  ”",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2B2E5A)
                                        .withOpacity(0.70),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Inner goal card
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 14, 14, 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.86),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE6E8F5)
                                          .withOpacity(0.9),
                                      width: 1,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x140E1330),
                                        blurRadius: 16,
                                        offset: Offset(0, 10),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Emoji + clock
                                          Container(
                                            width: 54,
                                            height: 74,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F3FF),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: const Color(0xFFE6E8F5),
                                                width: 1,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "💪⏰",
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                   Obx(() {
                                            final goal =
                                                _userController.goal.value;

                                            if (goal == null ||
                                                goal.startDate == null) {
                                              return Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "No upcoming goal",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color:
                                                            Color(0xFF2B2E5A),
                                                        height: 1.1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            PillarType myPillar = pillarFromApi(
                                                goal.pillar ??
                                                    "health_fitness");

                                            return Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    goal.title.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color(0xFF2B2E5A),
                                                      height: 1.1,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    "${AppConstant.formatGoalTime(goal.startDate!)} | ${myPillar.label}",
                                                    style: const TextStyle(
                                                      fontSize: 12.8,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF7A7FA8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "On in 12 mins · Show up for a healthier, stronger you",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2B2E5A)
                                              .withOpacity(0.55),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Get Ready button (pill)
                                SizedBox(
                                  width: 210,
                                  height: 46,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFFF8A3D),
                                          Color(0xFF7A3DFF),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF8A3D)
                                              .withOpacity(0.20),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: open goal / start preparation flow
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text(
                                        "Get Ready",
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Two small action cards
                        _GlassBarRow(
                          leftText: "View All Goals",
                          rightText: "History & Insights",
                          onLeft: () {
                            // TODO
                          },
                          onRight: () {
                            // TODO
                          },
                        ),

                        const SizedBox(height: 12),

                        // Bottom nav (glass)
                        _BottomGlassNav(
                          currentIndex: 0,
                          onTap: (i) {
                            // TODO: navigate tabs
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Frosted glass container (for big card)
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xB3FFFFFF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x220E1330),
                blurRadius: 22,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Two pill buttons row above bottom nav
class _GlassBarRow extends StatelessWidget {
  final String leftText;
  final String rightText;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const _GlassBarRow({
    required this.leftText,
    required this.rightText,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xA6FFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: _MiniAction(
                  icon: Icons.favorite_rounded,
                  text: leftText,
                  onTap: onLeft,
                ),
              ),
              Container(
                width: 1,
                height: 26,
                color: const Color(0xFFE6E8F5).withOpacity(0.8),
              ),
              Expanded(
                child: _MiniAction(
                  icon: Icons.bar_chart_rounded,
                  text: rightText,
                  onTap: onRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _MiniAction({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20, color: const Color(0xFF2B2E5A).withOpacity(0.62)),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2B2E5A).withOpacity(0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom glass navigation (Today/Goals/Insights/Profile)
class _BottomGlassNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomGlassNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xB3FFFFFF),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                label: "Today",
                icon: Icons.home_rounded,
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                label: "Goals",
                icon: Icons.check_circle_outline_rounded,
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                label: "Insights",
                icon: Icons.bar_chart_rounded,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                label: "Profile",
                icon: Icons.person_rounded,
                selected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFFFF8A3D)
        : const Color(0xFF2B2E5A).withOpacity(0.55);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
