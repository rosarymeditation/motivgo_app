import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoLandingTitle extends StatelessWidget {
  final String text;

  const MotivGoLandingTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: MotivGoTextTheme.whiteStrong,
      ),
    );
  }
}
