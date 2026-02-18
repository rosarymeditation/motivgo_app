import 'package:flutter/material.dart';

import '../utils/motivGoTheme.dart';

class MotivGoH2 extends StatelessWidget {
  final String text;

  const MotivGoH2(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: MotivGoTextTheme.textDark,
      ),
    );
  }
}
