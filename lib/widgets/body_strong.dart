import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoBodyStrong extends StatelessWidget {
  final String text;

  const MotivGoBodyStrong(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: MotivGoTextTheme.textDark,
        height: 1.35,
      ),
    );
  }
}
