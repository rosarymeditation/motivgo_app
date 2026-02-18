// import 'dart:io';
// import 'package:image/image.dart' as img;

// class FacePhotoValidator {
//   final FaceDetector _faceDetector;

//   FacePhotoValidator()
//       : _faceDetector = FaceDetector(
//           options: FaceDetectorOptions(
//             enableContours: true,
//             enableClassification: true,
//             enableLandmarks: true,
//             enableTracking: true,
//             performanceMode: FaceDetectorMode.accurate,
//           ),
//         );

//   Future<FaceValidationResult> validateProfilePhoto(File imageFile) async {
//     final errors = <String>[];
//     final warnings = <String>[];

//     // 1. Basic image checks
//     final image = img.decodeImage(await imageFile.readAsBytes());
//     if (image == null) {
//       return FaceValidationResult(
//         isValid: false,
//         errors: ['Invalid image file'],
//         warnings: [],
//       );
//     }

//     if (image.width < 500 || image.height < 500) {
//       errors.add('Image should be at least 500x500 pixels');
//     }

//     // 2. Face detection
//     final inputImage = InputImage.fromFilePath(imageFile.path);
//     final faces = await _faceDetector.processImage(inputImage);

//     if (faces.isEmpty) {
//       errors.add('No face detected in the photo');
//     } else if (faces.length > 1) {
//       errors.add('Multiple faces detected (solo photos only)');
//     } else {
//       final face = faces.first;

//       // 3. Face position and orientation checks
//       if ((face.headEulerAngleY ?? 0).abs() > 20) {
//         warnings.add('Face should be facing forward (not turned sideways)');
//       }

//       if ((face.headEulerAngleX ?? 0).abs() > 20) {
//         warnings.add('Face should be looking straight (not up/down)');
//       }

//       // // 4. Face features checks
//       // if (face.smilingProbability != null && face.smilingProbability! < 0.3) {
//       //   warnings.add('Smile would make your photo friendlier');
//       // }

//       if (face.leftEyeOpenProbability != null &&
//           face.leftEyeOpenProbability! < 0.3) {
//         errors.add('Eyes not clearly visible (no sunglasses)');
//       }

//       if (face.rightEyeOpenProbability != null &&
//           face.rightEyeOpenProbability! < 0.3) {
//         errors.add('Eyes not clearly visible (no sunglasses)');
//       }

//       // 5. Face size in image
//       final faceWidth = face.boundingBox.width;
//       final faceHeight = face.boundingBox.height;
//       final imageWidth = image.width.toDouble();
//       final imageHeight = image.height.toDouble();

//       if (faceWidth < imageWidth * 0.3 || faceHeight < imageHeight * 0.3) {
//         warnings.add('Face should occupy more of the frame');
//       }
//     }

//     return FaceValidationResult(
//       isValid: errors.isEmpty,
//       errors: errors,
//       warnings: warnings,
//     );
//   }

//   void dispose() {
//     _faceDetector.close();
//   }
// }

// class FaceValidationResult {
//   final bool isValid;
//   final List<String> errors;
//   final List<String> warnings;

//   FaceValidationResult({
//     required this.isValid,
//     required this.errors,
//     required this.warnings,
//   });
// }
