import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoCaption extends StatelessWidget {
  final String text;

  const MotivGoCaption(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: MotivGoTextTheme.textMid,
      ),
    );
  }
}
