import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insight_controller.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InsightController controller = Get.find<InsightController>();
    controller.loadInsights();

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
                  // Background image
                  const Image(
                    image: AssetImage("assets/images/background_3.png"),
                    fit: BoxFit.cover,
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
                        // Top bar

                        const SizedBox(height: 6),

                        Text(
                          "Insights",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.96),
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
                              width: 120,
                              color: Colors.white.withOpacity(0.16),
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
                              color: Colors.white.withOpacity(0.16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _WeeklyRecapCard(controller: controller),
                              const SizedBox(height: 12),
                              _FocusAreaCard(controller: controller),
                              const SizedBox(height: 12),
                              _ConsistencyCard(controller: controller),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
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

// ─────────────────────────────────────────
// Weekly Recap Card
// ─────────────────────────────────────────
class _WeeklyRecapCard extends StatelessWidget {
  final InsightController controller;
  const _WeeklyRecapCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Obx(() {
          final values = controller.weeklyValues;
          final labels = controller.weeklyLabels;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Weekly Recap",
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B2E5A),
                ),
              ),
              const SizedBox(height: 12),
              values.isEmpty
                  ? const _EmptyState(message: "No activity this week yet")
                  : _MiniWeekBars(
                      values: values,
                      labels: labels,
                    ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatPill(
                      label: "Streak:",
                      value: "${controller.streakDays.value} days",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatPill(
                      label: "Consistency:",
                      value: "${controller.consistency.value}%",
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Focus Area Card
// ─────────────────────────────────────────
class _FocusAreaCard extends StatelessWidget {
  final InsightController controller;
  const _FocusAreaCard({required this.controller});

  static const _colors = [
    Color(0xFFFF8A3D),
    Color(0xFF7A3DFF),
    Color(0xFFE37A5C),
    Color(0xFF3DAAFF),
    Color(0xFF3DFF8A),
    Color(0xFFFF3D8A),
  ];

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Obx(() {
          final areas = controller.focusAreas;

          if (areas.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Focus Area",
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2B2E5A),
                  ),
                ),
                SizedBox(height: 12),
                _EmptyState(message: "No pillar data yet"),
              ],
            );
          }

          // Sort by value descending
          final entries = areas.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final segments = entries.asMap().entries.map((e) {
            return _DonutSegment(
              e.value.value,
              _colors[e.key % _colors.length],
            );
          }).toList();

          final topEntry = entries.first;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: pillar list
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Focus Area",
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2B2E5A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...entries.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _FocusRowDot(
                            label: e.value.key,
                            percent: "${(e.value.value * 100).round()}%",
                            dotColor: _colors[e.key % _colors.length],
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Right: donut
              _DonutChart(
                size: 92,
                segments: segments,
                centerText: "${(topEntry.value * 100).round()}%",
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Consistency Card
// ─────────────────────────────────────────
class _ConsistencyCard extends StatelessWidget {
  final InsightController controller;
  const _ConsistencyCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Obx(() {
          final points = controller.consistencyPoints;
          final now = DateTime.now();

          final axisLabels = [
            _fmtDate(now.subtract(const Duration(days: 29))),
            _fmtDate(now.subtract(const Duration(days: 14))),
            _fmtDate(now),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Goal Consistency (30 Days)",
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B2E5A),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: points.isEmpty
                    ? const _EmptyState(message: "Not enough data yet")
                    : CustomPaint(
                        painter: _MiniLineChartPainter(
                          points: _toOffsets(points),
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: axisLabels.map((l) => _AxisTick(l)).toList(),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _fmtDate(DateTime dt) => "${dt.month}/${dt.day}";

  List<Offset> _toOffsets(List<double> pts) {
    if (pts.length < 2) return [];
    return List.generate(pts.length, (i) {
      return Offset(
        i / (pts.length - 1),
        pts[i].clamp(0.0, 1.0),
      );
    });
  }
}

// ─────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart_outlined,
              color: Color(0xFFB0B4D8), size: 18),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFFB0B4D8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Glass Card
// ─────────────────────────────────────────
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
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.86),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE6E8F5).withOpacity(0.9),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140E1330),
                blurRadius: 18,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Mini Week Bars
// ─────────────────────────────────────────
class _MiniWeekBars extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const _MiniWeekBars({required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(values.length, (i) {
        final v = values[i].clamp(0.0, 1.0);
        final isEmpty = v == 0.0;

        return Expanded(
          child: Column(
            children: [
              Container(
                height: 64,
                alignment: Alignment.bottomCenter,
                child: isEmpty
                    ? Container(
                        width: 14,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFE6E8F5),
                        ),
                      )
                    : Container(
                        width: 14,
                        height: 64 * v,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFF8A3D),
                              Color(0xFF7A3DFF),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x140E1330),
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[i],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7A7FA8),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
// Stat Pill
// ─────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2B2E5A),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7A7FA8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Focus Row Dot
// ─────────────────────────────────────────
class _FocusRowDot extends StatelessWidget {
  final String label;
  final String percent;
  final Color dotColor;

  const _FocusRowDot({
    required this.label,
    required this.percent,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2B2E5A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          percent,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w900,
            color: Color(0xFF7A7FA8),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Donut Chart
// ─────────────────────────────────────────
class _DonutChart extends StatelessWidget {
  final double size;
  final List<_DonutSegment> segments;
  final String centerText;

  const _DonutChart({
    required this.size,
    required this.segments,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(segments: segments),
          ),
          Container(
            width: size * 0.56,
            height: size * 0.56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
            ),
            child: Center(
              child: Text(
                centerText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B2E5A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutSegment {
  final double value;
  final Color color;
  const _DonutSegment(this.value, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  _DonutPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.22
      ..strokeCap = StrokeCap.round;

    double start = -3.1415926535 / 2;

    for (final seg in segments) {
      final sweep = seg.value.clamp(0.0, 1.0) * 3.1415926535 * 2;
      stroke.color = seg.color.withOpacity(0.92);
      canvas.drawArc(rect.deflate(radius * 0.10), start, sweep, false, stroke);
      start += sweep + 0.06;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => false;
}

// ─────────────────────────────────────────
// Line Chart Painter
// ─────────────────────────────────────────
class _MiniLineChartPainter extends CustomPainter {
  final List<Offset> points;
  _MiniLineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Grid lines
    final grid = Paint()
      ..color = const Color(0xFFE6E8F5)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Build path
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final p = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        // Smooth curve
        final prev = Offset(
          points[i - 1].dx * size.width,
          points[i - 1].dy * size.height,
        );
        final cpX = (prev.dx + p.dx) / 2;
        path.cubicTo(cpX, prev.dy, cpX, p.dy, p.dx, p.dy);
      }
    }

    // Fill
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x44FF8A3D), Color(0x007A3DFF)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Stroke
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF8A3D), Color(0xFF7A3DFF)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Dots — only first, middle, last to avoid clutter
    final dotPaint = Paint()..color = const Color(0xFFFF8A3D);
    final whitePaint = Paint()..color = Colors.white;

    final dotIndices = [
      0,
      points.length ~/ 2,
      points.length - 1,
    ];

    for (final idx in dotIndices) {
      final p = Offset(
        points[idx].dx * size.width,
        points[idx].dy * size.height,
      );
      canvas.drawCircle(p, 5, dotPaint);
      canvas.drawCircle(p, 2.5, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter old) =>
      old.points != points;
}

// ─────────────────────────────────────────
// Axis Tick
// ─────────────────────────────────────────
class _AxisTick extends StatelessWidget {
  final String text;
  const _AxisTick(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF7A7FA8),
      ),
    );
  }
}
