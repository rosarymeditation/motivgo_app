import 'package:flutter/material.dart';

class ThemedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final BoxConstraints? constraints;
  final Color? overrideColor;

  const ThemedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.constraints,
    this.overrideColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: BoxDecoration(
        color: overrideColor ?? (isDark ? Colors.grey[850] : Colors.white),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
