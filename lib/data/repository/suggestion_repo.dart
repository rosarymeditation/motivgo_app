import 'package:get/get.dart';
import 'package:motivgo/model/suggestion_model.dart';

import '../../../utils/constants.dart';
import '../api/api_client.dart';

class SuggestionRepo {
  final ApiClient apiClient;
  SuggestionRepo({required this.apiClient});

  Future<Response> create(SuggestionModel model) async {
    return apiClient.postData(AppConstant.SUGGESTION_URL, model.toJson());
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
