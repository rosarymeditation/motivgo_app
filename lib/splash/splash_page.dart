import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:motivgo/route/route_helpers.dart';
import 'package:motivgo/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Entry animations ──
  late final AnimationController _entryCtrl;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _loaderFade;

  // ── Ambient / orbital pulse ──
  late final AnimationController _orbCtrl;
  late final Animation<double> _orbAnim;

  // ── Ring spin ──
  late final AnimationController _ringCtrl;

  // ── Particle shimmer ──
  late final AnimationController _shimmerCtrl;

  static const _orange = Color(0xFFFF8A3D);
  static const _pink = Color(0xFFFF6B9D);
  static const _violet = Color(0xFF7A3DFF);
  static const _navy = Color(0xFF0E1330);
  static const _navyDeep = Color(0xFF07091C);

  @override
  void initState() {
    super.initState();

    // ── Entry: 0ms → 1800ms ──
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.38, 0.72, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.38, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.58, 0.88, curve: Curves.easeOut),
      ),
    );

    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Orbital pulse: infinite ──
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _orbAnim = CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut);

    // ── Ring spin: infinite ──
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    )..repeat();

    // ── Shimmer: infinite ──
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _entryCtrl.forward();
    Timer(const Duration(milliseconds: 4200), _navigate);
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstant.TOKEN);
    final loggedIn = token != null && token.isNotEmpty;
    if (!mounted) return;
    if (loggedIn) {
      Get.offAndToNamed(RouteHelpers.bottomNav);
    } else {
      Get.offAndToNamed(RouteHelpers.landingPage);
    }
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _orbCtrl.dispose();
    _ringCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: _navyDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Deep background ──
          _buildBackground(),

          // ── 2. Ambient orbs ──
          _buildAmbientOrbs(),

          // ── 3. Particle field ──
          _buildParticles(),

          // ── 4. Main content ──
          _buildContent(),

          // ── 5. Footer ──
          _buildFooter(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // BACKGROUND
  // ═══════════════════════════════════════
  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        const Image(
          image: AssetImage("assets/images/background_3.png"),
          fit: BoxFit.cover,
        ),

        // Deep navy overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xEE07091C),
                Color(0xCC0E1330),
                Color(0xDD07091C),
              ],
            ),
          ),
        ),

        // Subtle grain texture via CustomPaint
        CustomPaint(painter: _GrainPainter()),
      ],
    );
  }

  // ═══════════════════════════════════════
  // AMBIENT ORBS
  // ═══════════════════════════════════════
  Widget _buildAmbientOrbs() {
    return AnimatedBuilder(
      animation: _orbAnim,
      builder: (_, __) {
        final t = _orbAnim.value;
        return Stack(
          children: [
            // Orange orb — top left
            Positioned(
              top: -60 + t * 30,
              left: -60 + t * 20,
              child: _Orb(
                size: 280,
                color: _orange.withOpacity(0.12 + t * 0.06),
                blur: 80,
              ),
            ),

            // Violet orb — bottom right
            Positioned(
              bottom: -80 + t * 25,
              right: -60 + t * 15,
              child: _Orb(
                size: 300,
                color: _violet.withOpacity(0.14 + t * 0.06),
                blur: 90,
              ),
            ),

            // Pink orb — top right subtle
            Positioned(
              top: 100 - t * 20,
              right: -30 + t * 10,
              child: _Orb(
                size: 180,
                color: _pink.withOpacity(0.07 + t * 0.04),
                blur: 60,
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════
  // PARTICLES
  // ═══════════════════════════════════════
  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) => CustomPaint(
        painter: _ParticlePainter(
          progress: _shimmerCtrl.value,
          orange: _orange,
          violet: _violet,
          pink: _pink,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // MAIN CONTENT
  // ═══════════════════════════════════════
  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Logo mark with spinning ring ──
          FadeTransition(
            opacity: _logoFade,
            child: ScaleTransition(
              scale: _logoScale,
              child: _buildLogoMark(),
            ),
          ),

          SizedBox(height: 32.h),

          // ── App name ──
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
              child: _buildWordmark(),
            ),
          ),

          SizedBox(height: 12.h),

          // ── Tagline ──
          FadeTransition(
            opacity: _taglineFade,
            child: _buildTagline(),
          ),

          SizedBox(height: 40.h),

          // ── Loader ──
          FadeTransition(
            opacity: _loaderFade,
            child: _buildLoader(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoMark() {
    return SizedBox(
      width: 130.w,
      height: 130.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Spinning dashed outer ring ──
          AnimatedBuilder(
            animation: _ringCtrl,
            builder: (_, __) {
              return Transform.rotate(
                angle: _ringCtrl.value * 2 * pi,
                child: CustomPaint(
                  size: Size(130.w, 130.w),
                  painter: _DashedRingPainter(
                    color: _orange.withOpacity(0.35),
                    strokeWidth: 1.2,
                  ),
                ),
              );
            },
          ),

          // ── Reverse spinning inner ring ──
          AnimatedBuilder(
            animation: _ringCtrl,
            builder: (_, __) {
              return Transform.rotate(
                angle: -_ringCtrl.value * 2 * pi * 0.6,
                child: CustomPaint(
                  size: Size(108.w, 108.w),
                  painter: _DashedRingPainter(
                    color: _violet.withOpacity(0.25),
                    strokeWidth: 0.8,
                    dashCount: 6,
                  ),
                ),
              );
            },
          ),

          // ── Pulsing glow behind logo ──
          AnimatedBuilder(
            animation: _orbAnim,
            builder: (_, __) {
              return Container(
                width: 86.w,
                height: 86.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _orange.withOpacity(0.18 + _orbAnim.value * 0.14),
                      blurRadius: 36,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: _violet.withOpacity(0.14 + _orbAnim.value * 0.10),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Logo container ──
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.14),
                      Colors.white.withOpacity(0.06),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.20),
                    width: 1.2,
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: const Image(
                  image: AssetImage("assets/icon/Logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ── Small accent dots on ring ──
          ..._buildAccentDots(130.w / 2),
        ],
      ),
    );
  }

  List<Widget> _buildAccentDots(double radius) {
    final angles = [0.0, pi * 0.5, pi, pi * 1.5];
    final colors = [_orange, _pink, _violet, _pink];
    return angles.asMap().entries.map((e) {
      final angle = e.key;
      final color = colors[angle];
      final a = angles[angle];
      final x = cos(a) * (radius - 1);
      final y = sin(a) * (radius - 1);
      return Positioned(
        left: radius + x - 3,
        top: radius + y - 3,
        child: AnimatedBuilder(
          animation: _orbAnim,
          builder: (_, __) => Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5 + _orbAnim.value * 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildWordmark() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFE8E8FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'MOTIV',
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 8,
                color: Colors.white,
                fontFamily: 'Georgia',
              ),
            ),
            TextSpan(
              text: 'GO',
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 8,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [_orange, _pink, _violet],
                  ).createShader(Rect.fromLTWH(0, 0, 80.w, 40.h)),
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Column(
      children: [
        // Thin gradient line above
        Container(
          width: 60.w,
          height: 0.8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, _orange, Colors.transparent],
            ),
          ),
        ),

        SizedBox(height: 10.h),

        Text(
          'KEEP GOING, EVEN WHEN',
          style: TextStyle(
            fontSize: 9.5.sp,
            letterSpacing: 3.5,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.45),
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          'MOTIVATION FADES',
          style: TextStyle(
            fontSize: 9.5.sp,
            letterSpacing: 3.5,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.60),
          ),
        ),

        SizedBox(height: 10.h),

        // Thin gradient line below
        Container(
          width: 60.w,
          height: 0.8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, _violet, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return _GradientLoader(
      orange: _orange,
      pink: _pink,
      violet: _violet,
    );
  }

  Widget _buildFooter() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 28.h,
      child: FadeTransition(
        opacity: _loaderFade,
        child: Column(
          children: [
            Text(
              '© ${DateTime.now().year} MotivGo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withOpacity(0.22),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// AMBIENT ORB
// ═══════════════════════════════════════════
class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;

  const _Orb({
    required this.size,
    required this.color,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blur,
            spreadRadius: blur * 0.4,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// DASHED RING PAINTER
// ═══════════════════════════════════════════
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  _DashedRingPainter({
    required this.color,
    required this.strokeWidth,
    this.dashCount = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    final dashAngle = (2 * pi) / dashCount;
    final gapRatio = 0.35;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapRatio);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

// ═══════════════════════════════════════════
// PARTICLE PAINTER
// ═══════════════════════════════════════════
class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color orange;
  final Color violet;
  final Color pink;

  static final _rng = Random(42);
  static final _particles = List.generate(28, (i) {
    return _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      size: 1.2 + _rng.nextDouble() * 2.2,
      speed: 0.3 + _rng.nextDouble() * 0.7,
      phase: _rng.nextDouble(),
      colorIdx: i % 3,
    );
  });

  _ParticlePainter({
    required this.progress,
    required this.orange,
    required this.violet,
    required this.pink,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final opacity = (sin(t * pi)).clamp(0.0, 1.0) * 0.55;

      final color = p.colorIdx == 0
          ? orange
          : p.colorIdx == 1
              ? violet
              : pink;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final dx = p.x * size.width;
      final dy = (p.y - t * 0.3) * size.height;

      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, size, speed, phase;
  final int colorIdx;
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.colorIdx,
  });
}

// ═══════════════════════════════════════════
// GRAIN PAINTER
// ═══════════════════════════════════════════
class _GrainPainter extends CustomPainter {
  static final _rng = Random(99);
  static final _grains = List.generate(
      200,
      (i) => [
            _rng.nextDouble(),
            _rng.nextDouble(),
            0.5 + _rng.nextDouble(),
          ]);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.018);
    for (final g in _grains) {
      canvas.drawCircle(
        Offset(g[0] * size.width, g[1] * size.height),
        g[2],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => false;
}

// ═══════════════════════════════════════════
// GRADIENT LOADER
// ═══════════════════════════════════════════
class _GradientLoader extends StatefulWidget {
  final Color orange;
  final Color pink;
  final Color violet;

  const _GradientLoader({
    required this.orange,
    required this.pink,
    required this.violet,
  });

  @override
  State<_GradientLoader> createState() => _GradientLoaderState();
}

class _GradientLoaderState extends State<_GradientLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final t = _anim.value;

        double bump(double center) =>
            (1 - ((t - center).abs() * 3.5)).clamp(0.0, 1.0);

        return Column(
          children: [
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(widget.orange, bump(0.18)),
                SizedBox(width: 10.w),
                _dot(widget.pink, bump(0.50)),
                SizedBox(width: 10.w),
                _dot(widget.violet, bump(0.82)),
              ],
            ),

            SizedBox(height: 14.h),

            // Loading bar
            Container(
              width: 80.w,
              height: 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withOpacity(0.08),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (t * 1.0).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [widget.orange, widget.pink, widget.violet],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.orange.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dot(Color color, double scale) {
    final size = (5.5 + 4.5 * scale).sp;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.7 + scale * 0.3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4 * scale),
            blurRadius: 10,
            spreadRadius: scale * 2,
          ),
        ],
      ),
    );
  }
}
