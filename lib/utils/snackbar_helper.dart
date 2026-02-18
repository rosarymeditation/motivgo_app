import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar(
    BuildContext context, {
    required String message,
    bool isError = false,
    //Color backgroundColor = Colors.blue,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        behavior: behavior,
        backgroundColor: isError ? Colors.amber.shade400 : Colors.blue.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
      ),
    );
  }
}
