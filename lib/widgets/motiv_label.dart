import 'package:flutter/material.dart';

class MotivGoLabel extends StatelessWidget {
  final String text;

  const MotivGoLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF61679A),
        ),
      ),
    );
  }
}
