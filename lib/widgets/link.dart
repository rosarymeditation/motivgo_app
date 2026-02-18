import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const MotivGoLink({
    super.key,
    required this.text,
    required this.onTap,
    this.color = MotivGoTextTheme.textDark
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style:  TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color:color,
        ),
      ),
    );
  }
}
