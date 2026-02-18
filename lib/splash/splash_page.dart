import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rosary/route/route_helpers.dart';
import 'package:rosary/utils/constants.dart';
import 'package:rosary/utils/register_cache.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _pulseCtrl;

  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _fadeIn = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic);

    _scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutBack),
    );

    _slideUp =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );

    _pulse = Tween<double>(begin: 0.10, end: 0.30).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _enterCtrl.forward();
    Timer(const Duration(seconds: 4), _handleNavigation);
  }

  Future<void> _handleNavigation() async {
    final hasLogin = await isUserLoggedIn();
    // final hasCompleted = await CompletedRegisterPrefs.hasCompletedReg();

    if (!mounted) return;


    //Get.offAndToNamed(RouteHelpers.landingPage);
    if (hasLogin) {
      Get.offAndToNamed(RouteHelpers.dashboard);
    } else {
      Get.offAndToNamed(RouteHelpers.landingPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    // Brand colors (match your purple → orange premium UI)
    const deepPurple = Color(0xFF2B1B4D);
    const midPurple = Color(0xFF4A2F7A);
    const warmPink = Color(0xFFB24A7A);
    const warmOrange = Color(0xFFFF8A3D);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Option A (recommended): use your generated sunrise background image
          // Put the PNG/JPG in assets/images/splash_bg.png and add to pubspec.yaml
          const Image(
            image: AssetImage("assets/images/background_3.png"),
            fit: BoxFit.cover,
          ),

          // Subtle dark vignette for premium contrast
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.1,
                colors: [
                  Color(0x00000000),
                  Color(0x66000000),
                ],
              ),
            ),
          ),

          // Brand gradient tint (ties to your onboarding screens)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xAA2B1B4D), // deep purple overlay
                  Color(0x663A2360), // mid purple overlay
                  Color(0x003A2360), // transparent
                  Color(0x55FF8A3D), // warm orange overlay
                ],
              ),
            ),
          ),

          // Glass blur panel + content
          Center(
            child: SlideTransition(
              position: _slideUp,
              child: FadeTransition(
                opacity: _fadeIn,
                child: ScaleTransition(
                  scale: _scaleIn,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: _GlassCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo with premium glow ring (single-color logo sits well here)
                          AnimatedBuilder(
                            animation: _pulse,
                            builder: (_, __) {
                              return Container(
                                width: 108.w,
                                height: 108.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          warmOrange.withOpacity(_pulse.value),
                                      blurRadius: 32,
                                      spreadRadius: 6,
                                    ),
                                    BoxShadow(
                                      color: midPurple
                                          .withOpacity(_pulse.value * 0.9),
                                      blurRadius: 26,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.10),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.22),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/icon/logo.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 16.h),

                          // App name
                          Text(
                            "MotivGo",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Tagline
                          Text(
                            "Keep going, even when motivation fades.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              height: 1.35,
                              letterSpacing: 0.2,
                              color: Colors.white.withOpacity(0.82),
                            ),
                          ),

                          SizedBox(height: 18.h),

                          // Tiny premium loading indicator
                          _MiniLoader(
                            left: deepPurple,
                            mid: warmPink,
                            right: warmOrange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom subtle copyright / version (optional)
          Positioned(
            left: 0,
            right: 0,
            bottom: 26.h,
            child: Text(
              "© ${DateTime.now().year} MotivGo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withOpacity(0.55),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstant.TOKEN);
    return token != null && token.isNotEmpty;
  }
}

/// A premium frosted-glass card (no external packages)
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Minimal premium loader with soft dots
class _MiniLoader extends StatefulWidget {
  const _MiniLoader({
    required this.left,
    required this.mid,
    required this.right,
  });

  final Color left;
  final Color mid;
  final Color right;

  @override
  State<_MiniLoader> createState() => _MiniLoaderState();
}

class _MiniLoaderState extends State<_MiniLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, __) {
        final t = _a.value;
        double bump(double x) => (1 - (t - x).abs() * 3).clamp(0.0, 1.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dot(widget.left, bump(0.2)),
            SizedBox(width: 8.w),
            _dot(widget.mid, bump(0.5)),
            SizedBox(width: 8.w),
            _dot(widget.right, bump(0.8)),
          ],
        );
      },
    );
  }

  Widget _dot(Color c, double k) {
    final size = (6.5 + 4.5 * k).sp;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.35),
            blurRadius: 12,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );
  }
}
