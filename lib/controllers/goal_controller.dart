import 'package:get/get.dart';
import 'package:rosary/controllers/pillar_controller.dart';
import '../data/repository/user_repo.dart';
import '../model/DTO/goal_and_pillars.dart';
import '../model/goal_model.dart';
import '../model/response_model.dart';
import '../model/user_model.dart';
import '../utils/hive_storage.dart';
import '../utils/notification_service.dart';

class GoalController extends GetxController {
  final UserRepo userRepo;
  GoalController({required this.userRepo});

  var isLoading = false.obs;

  /// Save goal & update user
  Future<ResponseModel> saveGoalAndUpdateUser({
    required String goalTitle,
    required String pillar,
    required DateTime scheduledAt,
    required String motivationStyle,
    required String format,
    required bool faithToggle,
  }) async {
    final PillarController _pillerController = Get.find<PillarController>();
    isLoading.value = true;
    late ResponseModel responseModel;

    try {
      // 1️⃣ Prepare goal model
      final goal = GoalModel(
        title: goalTitle,
        pillar: pillar,
        reminderTime:
            "${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}",
        startDate: scheduledAt,
        motivationStyle: motivationStyle,
        format: format.toLowerCase(),
        faithToggle: faithToggle,
      );

      final timezone = "";
      // 2️⃣ API call to update user + create goal
      final model = UpdateUserWithGoalRequest(
          goal: goal,
          focusPillars: _pillerController.selected,
          timezone: timezone);
      final response = await userRepo.updateUser(model);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final userJson = response.body['user'];
        final goalJson = response.body['goal'];

        // Save locally
        final storage = HiveStorage();
        if (userJson != null) {
          await storage.saveUser(UserModel.fromJson({"user": userJson}));
        }
        if (goalJson != null) {
          await AlarmService().scheduleAlarm(
            id: goal.hashCode, // unique id per goal
            title: "Goal Reminder",
            body: goalTitle.trim(),
            scheduledDate: scheduledAt,
            //remoteAudioUrl: "https://yourserver.com/audio.mp3", // optional
          );
          await storage.saveGoal(GoalModel.fromJson(goalJson));
        }

        responseModel = ResponseModel(true, "Goal saved successfully");
      } else {
        responseModel =
            ResponseModel(false, response.body['message'] ?? "Unknown error");
      }
    } catch (e) {
      print(e);
      responseModel = ResponseModel(false, "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }

    return responseModel;
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
