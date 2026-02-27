import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/pillar_controller.dart';
import '../controllers/user_controller.dart';
import '../enums/pillar_type.dart';
import '../route/route_helpers.dart';
import '../widgets/primary_button.dart';

class FocusAreasPage extends StatelessWidget {
  FocusAreasPage({super.key});

  final PillarController pillarC = Get.find<PillarController>();
  final UserController userC = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    // ✅ Preload user's saved pillars — these become immutable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saved = (userC.user.value?.focusPillars ?? [])
          .map((s) => pillarFromApi(s))
          .toList();

      if (saved.isNotEmpty) {
        pillarC.setSelectedPillars(saved); // locks them as immutable
      }
    });

    const bg = Color(0xFFF3F5FF);
    const card = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A0E1330),
                    blurRadius: 28,
                    offset: Offset(0, 18),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  children: [
                    // ── Top row ──
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: const Color(0xFF4C4F7C),
                        ),
                        const Spacer(),
                        const SizedBox(width: 44),
                      ],
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      "Choose Your Focus Areas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2B2E5A),
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── Divider + dot ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 1,
                            width: 110,
                            color: const Color(0xFFE6E8F5)),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C82B8),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                            height: 1,
                            width: 110,
                            color: const Color(0xFFE6E8F5)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Pick the areas where you want to grow.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A7FA8),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Immutable hint banner ──
                    Obx(() {
                      final locked = pillarC.immutablePillars;
                      if (locked.isEmpty) return const SizedBox.shrink();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFE6E8F5), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded,
                                size: 14, color: Color(0xFF7A7FA8)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${locked.length} pillar${locked.length > 1 ? 's' : ''} locked from your profile",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF7A7FA8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // ── Free tier counter ──
                    Obx(() {
                      final isFree = pillarC.tier.value != "premium";
                      if (!isFree) return const SizedBox.shrink();

                      final count = pillarC.desired.length;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          "$count selected • Free activates 2 pillars",
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A7FA8),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 6),

                    // ── Pillar tiles ──
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: PillarType.values.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final pillar = PillarType.values[i];
                          return _PillarTile(
                            controller: pillarC,
                            pillar: pillar,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    MotivGoPrimaryButton(
                      text: "Next",
                      onPressed: () {
                        pillarC.commitDesiredToSelected();

                        final isFree = pillarC.tier.value != "premium";
                        if (isFree && pillarC.desired.length > 2) {
                          _showUpgradeModal(
                            onUpgrade: () {
                              // Get.toNamed(RouteHelpers.paywallPage);
                            },
                            onContinueFree: () {
                              Get.back();
                              print(pillarC.isForFirstGoal.value);
                              if (pillarC.isForFirstGoal.value) {
                                Get.toNamed(RouteHelpers.firstGoalPage);
                              } else {
                                Get.toNamed(RouteHelpers.newGoalPage);
                              }
                            },
                          );
                          return;
                        }
                        print(pillarC.isForFirstGoal.value);
                        if (pillarC.isForFirstGoal.value) {
                          print("terd");
                          Get.toNamed(RouteHelpers.firstGoalPage);
                        } else {
                          print("roororo");
                          Get.toNamed(RouteHelpers.newGoalPage);
                        }
                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUpgradeModal({
    required VoidCallback onUpgrade,
    required VoidCallback onContinueFree,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8F5),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "Unlock All Focus Areas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2B2E5A),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Free activates 2 pillars to start.\nPremium unlocks all your selected pillars + unlimited goals.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7A7FA8),
              ),
            ),
            const SizedBox(height: 16),
            MotivGoPrimaryButton(
              text: "Upgrade to Premium",
              onPressed: onUpgrade,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onContinueFree,
              child: const Text(
                "Continue with 2 pillars",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2B2E5A),
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
// Pillar Tile — respects immutable state
// ─────────────────────────────────────────
class _PillarTile extends StatelessWidget {
  const _PillarTile({
    required this.controller,
    required this.pillar,
  });

  final PillarController controller;
  final PillarType pillar;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.desired.contains(pillar) ||
          controller.isImmutable(pillar); // ✅ immutable = always selected
      final locked = controller.isImmutable(pillar);

      final title = (pillar == PillarType.emotionalWellness)
          ? "Emotional\nMental Wellness"
          : pillar.label;

      return FocusAreaTile(
        title: title,
        subtitle: pillar.subtitle,
        iconAsset: pillar.iconAsset,
        selected: selected,
        locked: locked, // ✅ pass locked state
        onTap: locked
            ? () => _showLockedSnackbar(pillar) // ✅ show message if locked
            : () => controller.toggleDesired(pillar),
      );
    });
  }

  void _showLockedSnackbar(PillarType pillar) {
    Get.snackbar(
      '🔒 Locked',
      '${pillar.label} is part of your profile and cannot be removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2B2E5A),
      colorText: Colors.white,
      borderRadius: 14,
      margin: const EdgeInsets.all(14),
      duration: const Duration(seconds: 2),
    );
  }
}

// ─────────────────────────────────────────
// Focus Area Tile Widget
// ─────────────────────────────────────────
class FocusAreaTile extends StatelessWidget {
  const FocusAreaTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
    this.locked = false, // ✅ new param
  });

  final String title;
  final String subtitle;
  final String iconAsset;
  final bool selected;
  final bool locked; // ✅
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // ✅ locked = purple tint border, selected = orange, default = grey
            color: locked
                ? const Color(0xFF7A3DFF).withOpacity(0.3)
                : selected
                    ? const Color(0xFFE37A5C).withOpacity(0.3)
                    : const Color(0xFFE6E8F5),
            width: locked || selected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080E1330),
              blurRadius: 12,
              offset: Offset(0, 8),
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: locked
                // ✅ locked = subtle purple tint background
                ? [
                    const Color(0xFFF8F5FF),
                    const Color(0xFFEEE8FF),
                  ]
                : const [
                    Color(0xFFFFF8EE),
                    Color(0xFFF7E9FF),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Background blob
            Positioned(
              right: -22,
              bottom: -26,
              child: Container(
                width: 170,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: locked
                        ? [
                            const Color(0xFF7A3DFF).withOpacity(0.12),
                            const Color(0xFF7A3DFF).withOpacity(0.06),
                          ]
                        : [
                            const Color(0xFFFF8A3D).withOpacity(0.18),
                            const Color(0xFF7A3DFF).withOpacity(0.14),
                          ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // ── Icon ──
                  Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFFE6E8F5), width: 1),
                    ),
                    child: Image.asset(
                      height: 150,
                      width: 150,
                      iconAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF7A7FA8),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ── Title + subtitle ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: locked
                                      ? const Color(
                                          0xFF4C3D8F) // ✅ purple tint if locked
                                      : const Color(0xFF2B2E5A),
                                  height: 1.05,
                                ),
                              ),
                            ),
                            // ✅ Lock badge next to title
                          ],
                        ),
                        if (subtitle.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7A7FA8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── Right indicator ──
                  if (locked)
                    // ✅ Lock icon circle for immutable
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7A3DFF).withOpacity(0.12),
                        border: Border.all(
                          color: const Color(0xFF7A3DFF).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        size: 12,
                        color: Color(0xFF7A3DFF),
                      ),
                    )
                  else if (selected)
                    // ✅ Check icon for selected
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE37A5C),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE37A5C).withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: const Icon(Icons.check,
                          size: 15, color: Colors.white),
                    )
                  else
                    // Empty circle for unselected
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFE6E8F5), width: 1),
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
