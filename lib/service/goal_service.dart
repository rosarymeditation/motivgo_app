// goal_service.dart

import 'package:hive/hive.dart';
import 'package:rosary/utils/hive_storage.dart';

import '../model/goal_model.dart';

class GoalService {

  static Future<Box<GoalModel>> _openBox() async {
    if (!Hive.isBoxOpen(HiveStorage.goalBox)) {
      return await Hive.openBox<GoalModel>(HiveStorage.goalBox);
    }
    return Hive.box<GoalModel>(HiveStorage.goalBox);
  }

  static Future<List<GoalModel>> getGoalsDueToday() async {
    final box = await _openBox();
    return box.values.where((goal) => goal.isDueToday()).toList()
      ..sort((a, b) {
        final aTime = (a.hour ?? 0) * 60 + (a.minute ?? 0);
        final bTime = (b.hour ?? 0) * 60 + (b.minute ?? 0);
        return aTime.compareTo(bTime);
      });
  }

  static Future<List<GoalModel>> getPendingDueToday() async {
    final today = _toDateKey(DateTime.now());
    final allToday = await getGoalsDueToday();
    return allToday.where((g) => g.lastCompletedDateKey != today).toList();
  }

  static String _toDateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
