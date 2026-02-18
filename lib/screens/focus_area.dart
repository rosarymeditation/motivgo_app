import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../enums/pillar_type.dart';
import '../route/route_helpers.dart';
import '../widgets/primary_button.dart';

// ✅ controller + enum + extension
import '../controllers/pillar_controller.dart';

class FocusAreasPage extends StatelessWidget {
  FocusAreasPage({super.key});

  // Put once (or bind in bindings)
  final PillarController pillarC = Get.put(PillarController());

  @override
  Widget build(BuildContext context) {
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
                    // Top row
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

                    // Divider + dot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 110,
                          color: const Color(0xFFE6E8F5),
                        ),
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
                          color: const Color(0xFFE6E8F5),
                        ),
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

                    // ✅ Optional: show counter for free users
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

                    // ✅ Tiles (generated from enum; title/subtitle/icon come from extension)
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
                        // Commit onboarding choices into actual selected (trims to 2 for free)
                        pillarC.commitDesiredToSelected();

                        // Soft paywall if free + selected more than 2 in desired
                        final isFree = pillarC.tier.value != "premium";
                        if (isFree && pillarC.desired.length > 2) {
                          _showUpgradeModal(
                            onUpgrade: () {
                              // TODO: navigate to subscription screen
                              // Get.toNamed(RouteHelpers.paywallPage);
                            },
                            onContinueFree: () {
                              Get.back();
                              Get.toNamed(RouteHelpers.firstGoalPage);
                            },
                          );
                          return;
                        }

                        Get.toNamed(RouteHelpers.firstGoalPage);
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

/// A tile that binds to PillarController (uses desired list during onboarding)
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
      final selected = controller.desired.contains(pillar);

      // If you want to show a 2-line title for the emotional wellness tile,
      // handle it here without hardcoding subtitles/icons in the UI.
      final title = (pillar == PillarType.emotionalWellness)
          ? "Emotional\nMental Wellness"
          : pillar.label;

      return FocusAreaTile(
        title: title,
        subtitle: pillar.subtitle,
        iconAsset: pillar.iconAsset,
        selected: selected,
        onTap: () => controller.toggleDesired(pillar),
      );
    });
  }
}

/// ===== Tile widget styled to match screenshot =====
class FocusAreaTile extends StatelessWidget {
  const FocusAreaTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 74.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080E1330),
              blurRadius: 12,
              offset: Offset(0, 8),
            )
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF8EE),
              Color(0xFFF7E9FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -22,
              bottom: -26,
              child: Container(
                width: 170,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
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
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFFE6E8F5), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        iconAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFF7A7FA8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2B2E5A),
                            height: 1.05,
                          ),
                        ),
                        if (subtitle.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
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
                  if (selected)
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
