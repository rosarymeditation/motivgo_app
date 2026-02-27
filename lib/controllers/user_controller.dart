import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/repository/user_repo.dart';
import '../model/goal_model.dart';
import '../model/response_model.dart';
import '../model/user_model.dart';
import '../utils/hive_storage.dart';

class UserController extends GetxController {
  final UserRepo userRepo;
  UserController({required this.userRepo});
  var user = Rxn<UserModel>();
  var goal = Rxn<GoalModel>();

  var goals = RxList<GoalModel>([]);
 
  void loadGoals() {
    final storage = HiveStorage();
    goals.value = storage.getAllGoals();
    user.value = storage.getUser();
    print("Users---------------------------------------------------");
    print(user.value?.firstName);
    print("Users---------------------------------------------------");
  }

  

  late Box<UserModel> _userBox;
  @override
  void onInit() {
    super.onInit();
    _userBox = Hive.box<UserModel>(HiveStorage.userBox);

    // Load user from Hive
    loadUser();
   // loadGoalOccurences();
  }

  void loadUser() {
    final storage = HiveStorage();

    print("User loaded from Hive");
    user.value = storage.getUser();
    goal.value = storage.getNextGoal();
    storage.getAllGoals().forEach((res) => print(res.toJson()));
    // print("Stored user: ${storedUser?.toJson()}");
    // print(storedUser.toJson());
  }

  var isLoading = false.obs;

  Future<ResponseModel> register(
      String email, String password, String firstName) async {
    isLoading.value = true;
    late ResponseModel responseModel;

    try {
      var model = UserModel(
        email: email,
        password: password,
        firstName: firstName,
      );

      Response response = await userRepo.register(model);

      if (response.statusCode != 200) {
        return ResponseModel(
          false,
          response.body["message"] ?? "Unknown error",
        );
      }

      final token = response.body["token"]?.toString();
      final userJson = response.body["user"];

      if (token == null || token.isEmpty || userJson == null) {
        return ResponseModel(
            false, "Token or user missing from server response");
      }
      print(response.body);
      final storage = HiveStorage();

      // Save token
      await storage.saveToken(token);
      userRepo.saveUserToken(token);

      // Save user
      final hiveUser = UserModel.fromJson(userJson);

      await storage.saveUser(hiveUser);

      // Debug
      final savedUser = storage.getUser();
      print("Saved user: ${savedUser?.email}, id: ${savedUser?.id}");

      responseModel = ResponseModel(true, "OK");
    } catch (e) {
      responseModel = ResponseModel(false, "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }

    return responseModel;
  }

  String getGreeting() {
    final name = user.value?.firstName ?? "";
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "🌅 Good Morning${name.isNotEmpty ? ', $name' : ''}!";
    } else if (hour >= 12 && hour < 17) {
      return "☀️ Good Afternoon${name.isNotEmpty ? ', $name' : ''}!";
    } else if (hour >= 17 && hour < 21) {
      return "🌇 Good Evening${name.isNotEmpty ? ', $name' : ''}!";
    } else {
      return "🌙 Good Night${name.isNotEmpty ? ', $name' : ''}!";
    }
  }
  // Future<void> setTemplate(String template) async {
  //   //await userRepo.saveTemplate(template);
  //   await getTemplate();
  //   update();
  // }

  // Future<void> getTemplate() async {
  //   _templateType = await userRepo.getTemplate();
  //   update();
  // }

  // Future<bool> setHasSeenSettings() {
  //   return userRepo.setHasSeenSettings();
  // }

  // bool getHasSeenSettings() {
  //   return userRepo.getHasSeenSettings();
  // }
  GoalModel? getNextGoal() {
    final storage = HiveStorage();
    return storage.getNextGoal();
  }

  DateTime? getNextOccurrence(GoalModel goal) {
    final storage = HiveStorage();
    return storage.getNextTriggerForGoal(goal);
  }

  Future<bool> clearSharedData() async {
    final storage = HiveStorage();
    await storage.clearAuth();
    return userRepo.clearSharedData();
  }
}
