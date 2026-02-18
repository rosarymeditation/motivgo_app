

import 'package:flutter/material.dart';
import 'package:rosary/utils/motivGoTheme.dart';

class MotivGoBody extends StatelessWidget {
  final String text;
  final TextAlign align;

  const MotivGoBody(
    this.text, {
    super.key,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MotivGoTextTheme.textMid,
        height: 1.4,
      ),
    );
  }
}
