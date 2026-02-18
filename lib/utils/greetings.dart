import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting

Future<void> checkAndShowGreeting(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();

  String period;
  if (now.hour < 12) {
    period = 'morning';
  } else if (now.hour < 17) {
    period = 'afternoon';
  } else {
    period = 'evening';
  }

  String todayKey = 'greetingShown_${period}_${DateFormat('yyyy-MM-dd').format(now)}';

  bool alreadyShown = prefs.getBool(todayKey) ?? false;

  if (!alreadyShown) {
    showIgboGreetingsDialog(context, period);
    await prefs.setBool(todayKey, true); // Mark it as shown
  }
}

void showIgboGreetingsDialog(BuildContext context, String period) {
  Map<String, Map<String, String>> greetings = {
    'morning': {
      'igbo': 'Ụtụtụ ọma',
      'english': 'Good Morning',
      'pronunciation': 'oo-too-too oh-mah',
      'emoji': '🌅',
    },
    'afternoon': {
      'igbo': 'Ehihie ọma',
      'english': 'Good Afternoon',
      'pronunciation': 'ay-hee-hay oh-mah',
      'emoji': '☀️',
    },
    'evening': {
      'igbo': 'Mgbede ọma',
      'english': 'Good Evening',
      'pronunciation': 'mg-beh-deh oh-mah',
      'emoji': '🌇',
    },
  };

  final greeting = greetings[period]!;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('${greeting['emoji']} ${greeting['english']}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Igbo: ${greeting['igbo']}'),
          Text('Pronunciation: ${greeting['pronunciation']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Thanks!'),
        ),
      ],
    ),
  );
}
