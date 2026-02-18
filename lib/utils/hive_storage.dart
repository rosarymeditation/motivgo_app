import 'package:hive/hive.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../model/goal_model.dart';
import '../model/user_model.dart';

class HiveStorage {
  static const authBox = 'authBox';
  static const userBox = 'userBox';
  static const goalBox = 'goalBox'; // new box for goals

  static const _tokenKey = 'token';
  static const userKey = 'me';
  static const _goalKey = 'firstGoal'; // optional key for single goal

  Future<void> saveToken(String token) async {
    final box = Hive.box(authBox);
    await box.put(_tokenKey, token);
  }

  // Future<void> saveGoal(GoalModel goal) async {
  //   final box = Hive.box<GoalModel>(goalBox);
  //   await box.put(_goalKey, goal);
  // }
  // Save a single goal with a Mongo-style ID
  Future<void> saveGoal(GoalModel goal) async {
    final box = Hive.box<GoalModel>(goalBox);

    // Generate a Mongo-like ID if goal.id is null
    final id = goal.id ?? ObjectId().toHexString();
    goal.id = id;

    await box.put(id, goal);
  }

  // Get a single goal by ID
  GoalModel? getGoal(String id) {
    final box = Hive.box<GoalModel>(goalBox);
    return box.get(id);
  }

  // Delete a goal by ID
  Future<void> deleteGoal(String id) async {
    final box = Hive.box<GoalModel>(goalBox);
    await box.delete(id);
  }

  List<GoalModel> getAllGoals() {
    final box = Hive.box<GoalModel>(goalBox);
    return box.values.toList();
  }

  GoalModel? getNextGoal() {
    final allGoals = getAllGoals();

    // Only consider active goals with a non-null startDate in the future
    final now = DateTime.now();
    final upcomingGoals = allGoals
        .where((g) =>
            g.active == true &&
            g.startDate != null &&
            g.startDate!.isAfter(now))
        .toList();

    if (upcomingGoals.isEmpty) return null;

    // Find the goal with the earliest startDate among upcoming goals
    final soonest = upcomingGoals.reduce(
      (a, b) => a.startDate!.isBefore(b.startDate!) ? a : b,
    );

    return soonest;
  }

  String? getToken() {
    final box = Hive.box(authBox);
    return box.get(_tokenKey);
  }

  Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(userBox);
    await box.put(userKey, user);
  }

  UserModel? getUser() {
    final box = Hive.box<UserModel>(userBox);
    return box.get(userKey);
  }

  Future<void> clearAuth() async {
    await Hive.box(authBox).clear();
    await Hive.box<UserModel>(userBox).clear();
  }
}
