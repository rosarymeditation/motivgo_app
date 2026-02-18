import 'package:flutter/material.dart';

import '../utils/motivGoTheme.dart';

class MotivGoH1 extends StatelessWidget {
  final String text;
  final TextAlign align;

  const MotivGoH1(this.text, {super.key, this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: MotivGoTextTheme.textDark,
        height: 1.15,
      ),
    );
  }
}
