import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoLandingSubtitle extends StatelessWidget {
  final String text;

  const MotivGoLandingSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MotivGoTextTheme.whiteSoft,
        height: 1.4,
      ),
    );
  }
}
