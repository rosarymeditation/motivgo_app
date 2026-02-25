import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/route/route_helpers.dart';

import '../controllers/user_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E1330);

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
                  // ✅ Background image (use your same scenic gradient background)
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
                    child: Column(
                      children: [
                        // Top bar: back + settings bubble
                        // Row(
                        //   children: [
                        //     IconButton(
                        //       onPressed: () => Navigator.of(context).maybePop(),
                        //       icon:
                        //           const Icon(Icons.arrow_back_ios_new_rounded),
                        //       color: Colors.white.withOpacity(0.95),
                        //     ),
                        //     const Spacer(),
                        //     _CircleIconButton(
                        //       icon: Icons.settings_rounded,
                        //       onTap: () {
                        //         // TODO: open settings
                        //       },
                        //     )
                        //   ],
                        // ),

                        const SizedBox(height: 8),

                        // Avatar
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

                        Text(
                          "Samuel",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.96),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Tier badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8A3D).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFFF8A3D).withOpacity(0.55),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "Free Tier Member",
                            style: TextStyle(
                              fontSize: 12.8,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withOpacity(0.92),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Glass sections
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _GlassSection(
                                title: "Focus Pillars",
                                trailing: _SmallPillButton(
                                  text: "Edit",
                                  onTap: () {
                                    // TODO: edit pillars
                                  },
                                ),
                                child: Column(
                                  children: const [
                                    _PillarRow(
                                      emoji: "💪⏰",
                                      title: "Health & Fitness",
                                    ),
                                    SizedBox(height: 12),
                                    _PillarRow(
                                      emoji: "🧠",
                                      title: "Personal Growth",
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              _GlassSection(
                                title: "Account",
                                child: Column(
                                  children: [
                                    _AccountRow(
                                      icon: Icons.access_time_rounded,
                                      text: "Africa/Lagos",
                                    ),
                                    SizedBox(height: 12),
                                    _AccountRow(
                                      icon: Icons.mail_outline_rounded,
                                      text: "samuel@example.com",
                                    ),
                                    SizedBox(height: 12),
                                    _AccountRow(
                                      icon: Icons.logout_rounded,
                                      text: "Log out",
                                      isDanger: true,
                                      onTap: () async{
                                       await  _userController.clearSharedData();
                                        Get.toNamed(RouteHelpers.landingPage);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Upgrade button (gradient)
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
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: const Text(
                                      "Upgrade to Premium",
                                      style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
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

/// ======= Widgets =======

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.28), width: 1),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.92), size: 22),
      ),
    );
  }
}

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
          color: Colors.white.withOpacity(0.28),
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
            color: Colors.white.withOpacity(0.20),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
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

class _PillarRow extends StatelessWidget {
  final String emoji;
  final String title;

  const _PillarRow({
    required this.emoji,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.92),
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.75)),
        ],
      ),
    );
  }
}

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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.75)),
          ],
        ),
      ),
    );
  }
}
