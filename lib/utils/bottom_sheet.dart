import 'package:flutter/material.dart';

class BottomSheetClass {
  final BuildContext ctx;
  final Widget content;
  final String headerText;

  BottomSheetClass(
      {required this.ctx, required this.content, required this.headerText});

  void show() {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: content,
        );
      },
    );
  }
}
