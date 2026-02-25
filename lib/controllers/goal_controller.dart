import 'package:get/get.dart';
import 'package:rosary/controllers/pillar_controller.dart';
import '../data/repository/user_repo.dart';
import '../enums/time_enum.dart';
import '../model/DTO/goal_and_pillars.dart';
import '../model/goal_model.dart';
import '../model/goal_occurrence_model.dart';
import '../model/response_model.dart';
import '../model/user_model.dart';
import '../utils/hive_storage.dart';
import '../utils/notification_service.dart';

class GoalController extends GetxController {
  final UserRepo userRepo;
  GoalController({required this.userRepo});

  var isLoading = false.obs;
  var goalOccurences = RxList<GoalOccurrence>([]);
  var goals = RxList<GoalModel>([]);

  @override
  void onInit() {
    super.onInit();

    // Load user from Hive
    loadGoals();

    loadGoalOccurences();
  }

  void loadGoals() {
    final storage = HiveStorage();
    goals.value = storage.getAllGoals();

    print("Users---------------------------------------------------");
  }



  /// Save goal & update user
  Future<ResponseModel> saveGoalAndUpdateUser({
    required String goalTitle,
    required String pillar,
    required String repeatType,
    required int hour,
    required int minute,
    List<int>? weekdays,
    int? dayOfMonth,
    DateTime? scheduledAt,
    required String motivationStyle,
    required String format,
    required bool faithToggle,
  }) async {
    final PillarController pillarController = Get.find<PillarController>();

    isLoading.value = true;
    late ResponseModel responseModel;

    try {
      // ✅ Generate stable alarm ID
      final int alarmId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // ✅ Create goal model (NEW STRUCTURE)
      final goal = GoalModel(
        title: goalTitle,
        pillar: pillar,
        alarmId: alarmId,
        repeatType: repeatType,
        scheduledAt: repeatType == "none" ? scheduledAt : null,
        weekdays: repeatType == "weekly" ? weekdays : null,
        dayOfMonth: repeatType == "monthly" ? dayOfMonth : null,
        hour: hour,
        minute: minute,
        motivationStyle: motivationStyle,
        format: format.toLowerCase(),
        faithToggle: faithToggle,
        active: true,
      );

      // ✅ API call
      final model = UpdateUserWithGoalRequest(
        goal: goal,
        focusPillars: pillarController.selected,
        timezone: "",
      );

      final response = await userRepo.updateUser(model);

      if (response.statusCode == 200) {
        final userJson = response.body["user"];
        final goalJson = response.body['goal'];

        final storage = HiveStorage();
        if (userJson != null) {
          // await storage.saveUser(UserModel.fromJson({"user": userJson}));
          final hiveUser = UserModel.fromJson(userJson);

          await storage.saveUser(hiveUser);

          final savedUser = storage.getUser();
          print("Saved user: ${savedUser?.email}, id: ${savedUser?.id}");
        }
        // if (userJson != null) {
        //   await storage.saveUser(
        //     UserModel.fromJson({"user": userJson}),
        //   );
        // }

        GoalModel savedGoal = goal;

        if (goalJson != null) {
          savedGoal = GoalModel.fromJson(goalJson);
          await storage.saveGoal(savedGoal);
        } else {
          await storage.saveGoal(goal);
        }

        // ✅ SCHEDULE ALARM HERE (PROPERLY)
        await AlarmService().scheduleAlarm(
          id: alarmId,
          title: "Goal Reminder",
          body: goalTitle.trim(),
          hour: hour,
          minute: minute,
          repeatType: _mapRepeatType(repeatType),
          weekdays: weekdays,
          dayOfMonth: dayOfMonth,
        );

        responseModel = ResponseModel(true, "Goal saved successfully");
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ?? "Unknown error",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }

    return responseModel;
  }

  void loadGoalOccurences() {
    final storage = HiveStorage();
    goalOccurences.value = storage.getAllOccurences();
    print("Goal Occurences---------------------------------------------------");
    goalOccurences.forEach(
      (element) => print(element.toJson()),
    );

    print("Goal Occurences---------------------------------------------------");
  }

  RepeatType _mapRepeatType(String type) {
    switch (type) {
      case "weekly":
        return RepeatType.weekly;
      case "monthly":
        return RepeatType.monthly;
      case "yearly":
        return RepeatType.yearly;
      default:
        return RepeatType.none;
    }
  }
  // Future<String> getDeviceTimeZone() async {
  //   try {
  //     final String timezone = await FlutterNativeTimezone.getLocalTimezone();
  //     return timezone; // e.g., "America/New_York"
  //   } catch (e) {
  //     print("Could not get timezone: $e");
  //     return "UTC"; // fallback
  //   }
  // }
}
