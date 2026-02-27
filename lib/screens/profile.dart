import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/route/route_helpers.dart';

import '../controllers/goal_controller.dart';
import '../controllers/pillar_controller.dart';
import '../controllers/user_controller.dart';
import '../enums/pillar_type.dart';
import '../utils/hive_storage.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final UserController _userController = Get.find<UserController>();
  final GoalController _goalController = Get.find<GoalController>();
  final PillarController _pillarController = Get.find<PillarController>();

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E1330);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SingleChildScrollView(
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
                 // fit: StackFit.expand,
                  children: [
                    // Background
                    Opacity(
                      opacity: 0.3,
                      child: const Image(
                        image: AssetImage("assets/images/background_two.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
              
                    // Top overlay
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
              
                    // Bottom overlay
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
              
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                      child: Obx(() {
                        final user = _userController.user.value;
                        final isPremium = (user?.tier ?? '') == 'premium';
                        final goals = _goalController.goals;
                        final activeGoals =
                            goals.where((g) => g.active ?? true).length;
                        final pillars = (user?.focusPillars ?? [])
                            .map((s) => pillarFromApi(s))
                            .toList();
              
                        return Column(
                          children: [
                            const SizedBox(height: 8),
              
                            // ── Avatar ──
                            Container(
                              width: 86,
                              height: 86,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.55),
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 18,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/avatar.png",
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.white.withOpacity(0.18),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 42,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                  ),
                                ),
                              ),
                            ),
              
                            const SizedBox(height: 12),
              
                            // ── Name ──
                            Text(
                              user?.firstName ?? user?.email ?? 'User',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white.withOpacity(0.96),
                                letterSpacing: 0.2,
                              ),
                            ),
              
                            const SizedBox(height: 8),
              
                            // ── Tier badge ──
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isPremium
                                    ? const Color(0xFF7A3DFF).withOpacity(0.25)
                                    : const Color(0xFFFF8A3D).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isPremium
                                      ? const Color(0xFF7A3DFF).withOpacity(0.55)
                                      : const Color(0xFFFF8A3D).withOpacity(0.55),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPremium
                                        ? Icons.workspace_premium_rounded
                                        : Icons.star_outline_rounded,
                                    size: 13,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isPremium
                                        ? "Premium Member"
                                        : "Free Tier Member",
                                    style: TextStyle(
                                      fontSize: 12.8,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white.withOpacity(0.92),
                                    ),
                                  ),
                                ],
                              ),
                            ),
              
                            const SizedBox(height: 16),
              
                            // ── Stats row ──
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    value: '${goals.length}',
                                    label: 'Total Goals',
                                    icon: Icons.flag_rounded,
                                    color: const Color(0xFF7B82FF),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    value: '$activeGoals',
                                    label: 'Active',
                                    icon: Icons.check_circle_outline_rounded,
                                    color: const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    value: '${pillars.length}',
                                    label: 'Pillars',
                                    icon: Icons.category_rounded,
                                    color: const Color(0xFFFF8A3D),
                                  ),
                                ),
                              ],
                            ),
              
                            const SizedBox(height: 14),
              
                            // ── Scrollable sections ──
                            _GlassSection(
                              title: "Focus Pillars",
                              trailing: _SmallPillButton(
                                text: "Edit",
                                onTap: () {
                                  _pillarController
                                      .setSelectedPillars(pillars);
                                  Get.toNamed(RouteHelpers.focusAreaPage);
                                },
                              ),
                              child: pillars.isEmpty
                                  ? const _EmptyRow(
                                      message: "No pillars selected")
                                  : Column(
                                      children: pillars
                                          .map((pillar) => Padding(
                                                padding: EdgeInsets.only(
                                                  bottom:
                                                      pillar != pillars.last
                                                          ? 10
                                                          : 0,
                                                ),
                                                child: _PillarRow(
                                                    pillar: pillar),
                                              ))
                                          .toList(),
                                    ),
                            ),
                                      
                            const SizedBox(height: 14),
                                      
                            // Account Info
                            _GlassSection(
                              title: "Account",
                              child: Column(
                                children: [
                                  // Email
                                  _AccountRow(
                                    icon: Icons.mail_outline_rounded,
                                    text: user?.email ?? '—',
                                  ),
                                  const SizedBox(height: 10),
                                      
                                  // Goals count
                                  _AccountRow(
                                    icon: Icons.flag_outlined,
                                    text:
                                        '$activeGoals active goal${activeGoals != 1 ? 's' : ''}',
                                  ),
                                  const SizedBox(height: 10),
                                      
                                  // Logout
                                  _AccountRow(
                                    icon: Icons.logout_rounded,
                                    text: "Log out",
                                    isDanger: true,
                                    onTap: () async {
                                      await HiveStorage.resetAll();
                                      await _userController
                                          .clearSharedData();
                                      Get.offAllNamed(
                                          RouteHelpers.landingPage);
                                    },
                                  ),
                                ],
                              ),
                            ),
                                      
                            const SizedBox(height: 16),
                                      
                            // ── Upgrade button (hidden for premium) ──
                            if (!isPremium)
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
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
                                            .withOpacity(0.22),
                                        blurRadius: 18,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: go premium
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: const Text(
                                      "Upgrade to Premium ✨",
                                      style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                                      
                            const SizedBox(height: 16),
                                      
                            // App version
                            Center(
                              child: Text(
                                "MotivGo v1.0.0",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                                      
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Pillar Row — from PillarType enum
// ─────────────────────────────────────────
class _PillarRow extends StatelessWidget {
  final PillarType pillar;
  const _PillarRow({required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: pillar.color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: pillar.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(pillar.icon, color: pillar.color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              pillar.label,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.4), size: 18),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Empty Row
// ─────────────────────────────────────────
class _EmptyRow extends StatelessWidget {
  final String message;
  const _EmptyRow({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white38,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Glass Section
// ─────────────────────────────────────────
class _GlassSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _GlassSection({
    required this.title,
    required this.child,
    this.trailing,
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
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withOpacity(0.92),
                    ),
                  ),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Small Pill Button
// ─────────────────────────────────────────
class _SmallPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SmallPillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.8,
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(0.92),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Account Row
// ─────────────────────────────────────────
class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool isDanger;

  const _AccountRow({
    required this.icon,
    required this.text,
    this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDanger ? const Color(0xFFFF5B8A) : Colors.white.withOpacity(0.92);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDanger
              ? const Color(0xFFFF5B8A).withOpacity(0.08)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDanger
                ? const Color(0xFFFF5B8A).withOpacity(0.2)
                : Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.4), size: 18),
          ],
        ),
      ),
    );
  }
}
