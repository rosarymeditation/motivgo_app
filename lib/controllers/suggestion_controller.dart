import 'package:get/get.dart';
import 'package:motivgo/data/repository/suggestion_repo.dart';
import 'package:motivgo/model/suggestion_model.dart';
import '../model/response_model.dart';

class SuggestionController extends GetxController {
  final SuggestionRepo suggestionRepo;

  SuggestionController({required this.suggestionRepo});

  var isLoading = false.obs;

  Future<ResponseModel> sendSuggestion(SuggestionModel suggestion) async {
    isLoading.value = true;

    try {
      Response response = await suggestionRepo.create(suggestion);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(true, "Suggestion submitted successfully.");
      } else {
        return ResponseModel(
          false,
          response.body["message"] ?? "Failed to submit suggestion.",
        );
      }
    } catch (e) {
      return ResponseModel(false, "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
