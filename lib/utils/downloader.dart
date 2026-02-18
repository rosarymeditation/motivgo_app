import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyDownloader {
  static Future<String> getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  // Function to check if the file exists
  static Future<bool> checkIfFileExists(String fileName) async {
    final filePath = await getLocalFilePath(fileName);
    final file = File(filePath);
    return file.exists();
  }

  // Function to download and save the audio file
  static Future<void> downloadAudio(String url) async {
    final fileName = url.split('/').last;
    final fileExists = await checkIfFileExists(fileName);

    if (!fileExists) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final filePath = await getLocalFilePath(fileName);
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          print('Downloaded: $fileName');
        } else {
          throw Exception('Failed to download audio: $fileName');
        }
      } catch (e) {
        print('Error downloading $url: $e');
      }
    } else {
      print('File already exists: $fileName');
    }
  }

  // Function to download all audio files in the list
  static Future<void> downloadAllAudioFiles() async {
    // prefs.clear();
    for (var url in [
      // Add audio paths from audioRosaryList
      "luminous_audio_url".tr,
      "joyful_audio_url".tr,
      "glorious_audio_url".tr,
      "sorrowful_audio_url".tr,

      // Add audio paths from otherSongsPlaylist
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/amazing-grace.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/On+Eagle's+Wings.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/Here+I+Am%2C+Lord.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/Gregorian+Chants.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/Ave_Maria.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/n_imaculate%20mary.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/n_kneel_before_you.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/n_pange%20ligua.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/n_tatum%20ergo.mp3",
      "https://foodengo2.s3.eu-west-2.amazonaws.com/rosary/songs/n_kyrie_eleison.mp3",
    ]) {
      final fileName = url.split('/').last; // Extract file name from URL
      final fileExists = await checkIfFileExists(fileName);

      if (!fileExists) {
        try {
          await downloadAudio(url);
        } catch (e) {
          print('Error downloading $url: $e');
        }
      } else {
        print('File already exists: $fileName');
      }
    }
  }
}
