import 'package:get/get.dart';
import 'package:rosary/model/goal_model.dart';
import 'package:rosary/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';
import '../../model/DTO/goal_and_pillars.dart';
import '../api/api_client.dart';

class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  UserRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> register(UserModel model) async {
    return apiClient.postData(AppConstant.REGISTER_URL, model.toJson());
  }
  Future<Response> updateUser(UpdateUserWithGoalRequest model) async {
    return apiClient.postData(AppConstant.USER_UPDATE_URL, model.toJson());
  }
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstant.TOKEN, token);
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
