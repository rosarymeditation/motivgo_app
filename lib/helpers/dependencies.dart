import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rosary/controllers/goal_controller.dart';
import 'package:rosary/data/repository/goal_repo.dart';
import 'dart:convert'; // Importing dart:convert for json.decode

import 'package:rosary/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/user_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/user_repo.dart';
import '../model/language_model.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharePreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharePreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstant.BASE_URL, sharedPreferences: Get.find()));

  // // Repos

  // Get.lazyPut(
  //     () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => FeedRepo(apiClient: Get.find()));
  // Get.lazyPut(() =>
  //     BugFeedbackRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => GoalRepo(apiClient: Get.find()));
  // Get.lazyPut(() =>
  //     PersonalDetailRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Get.lazyPut(() => RelationshipGoalRepo(
  //     apiClient: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(
  //   () => ChatRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  // );
  // Get.lazyPut(
  //   () => FilterRepo(apiClient: Get.find()),
  // );
  // Get.lazyPut(
  //   () => DrawRepo(apiClient: Get.find()),
  // );
  // Get.lazyPut(
  //   () => FaithRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  // );
  // Get.lazyPut(
  //   () => PhotoVerifyRepo(
  //     apiClient: Get.find(),
  //   ),
  // );
  // Get.lazyPut(
  //   () => OccupationRepo(apiClient: Get.find()),
  // );
  // Get.lazyPut(
  //   () => BlockRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  // );
  // Get.lazyPut(
  //   () => MatchRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  // );
  // Get.lazyPut(
  //   () => PromptRepo(apiClient: Get.find()),
  // );
  // Get.lazyPut(
  //   () => FavoriteRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  // );

  // Get.lazyPut(() => HobbiesAndInterestRepo(
  //     apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controllers
  // Get.lazyPut(() => FilterController(filterRepo: Get.find()));
  // Get.lazyPut(() => PersonalDetailController(
  //     personalDetailRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => OccupationController(occupationRepo: Get.find()));
  // Get.lazyPut(() => FavoriteController(favoriteRepo: Get.find()));
  // Get.lazyPut(() =>
  //     FeedController(feedRepo: Get.find(), sharedPreferences: Get.find()));
  // //  Get.lazyPut(() => SocketServiceController());
  // Get.lazyPut(() =>
  //     MatchController(matchRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() =>
  //     FaithController(faithRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => PhotoVerifyController(photoVerifyRepo: Get.find()));
  // Get.lazyPut(() => ImageController(photoRepo: Get.find()));
  // Get.lazyPut(() => ChatController(chatRepo: Get.find()));
  // Get.lazyPut(() => RelationshipGoalController(
  //     relationshipGoalRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => HobbiesAndInterestController(
  //     hobbieRepo: Get.find(), sharedPreferences: Get.find()));

  // Get.lazyPut(() => SubscriptionController());

  // Get.lazyPut(() =>
  //     BlockController(blockRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => BugFeedbackController(
  //     bugFeedbackRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  // Get.lazyPut(() => SettingController());
  // Get.lazyPut(() =>
  //     UserController(userRepo: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => OTPController());
  // Get.lazyPut(() => DrawController(drawRepo: Get.find()));
  // Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => GoalController(userRepo: Get.find()));
  // Loading language data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstant.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson =
        json.decode(jsonStringValues); // Correct usage
    Map<String, String> languageJson =
        {}; // Renamed to avoid conflict with `json.decode`

    mappedJson.forEach((key, value) {
      print(value);
      print("Mapped json");
      languageJson[key] = value.toString(); // Using the renamed variable
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        languageJson;
  }

  return languages;
}
