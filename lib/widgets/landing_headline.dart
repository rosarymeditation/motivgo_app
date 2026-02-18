import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoLandingHeadline extends StatelessWidget {
  final String text;

  const MotivGoLandingHeadline(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: MotivGoTextTheme.whiteStrong,
        height: 1.25,
      ),
    );
  }
}
