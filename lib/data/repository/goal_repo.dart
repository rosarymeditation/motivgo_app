import 'package:get/get.dart';
import 'package:rosary/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';
import '../api/api_client.dart';

class GoalRepo {
  final ApiClient apiClient;
  GoalRepo({required this.apiClient});

  Future<Response> goalUserUpdate(UserModel model) async {
    return apiClient.postData(AppConstant.USER_UPDATE_URL, model.toJson());
  }
  Future<Response> updateUser(UserModel model) async {
    return apiClient.postData(AppConstant.USER_UPDATE_URL, model.toJson());
  }
  
  // Future<String> getTemplate() async {
  //   //return sharedPreferences.getString(AppConstant.TEMPLATE) ?? "";
  // }

  // Future<bool> saveTemplate(String template) async {
  //   return await sharedPreferences.setString(AppConstant.TEMPLATE, template);
  // }

  // Future<bool> setHasSeenSettings() async {
  //   return await sharedPreferences.setString(
  //       AppConstant.HAS_SEEN_SETTINGS, "true");
  // }

  // bool getHasSeenSettings() {
  //   return sharedPreferences.containsKey(AppConstant.HAS_SEEN_SETTINGS);
  // }
}
